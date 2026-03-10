#!/bin/bash

# iFlow CLI 安装脚本
# 支持全局安装（~/.iflow）和本地安装（./.iflow）

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 需要复制的目录
DIRS=("agents" "commands" "context" "script" "skills")

# 检查并安装 bun
check_and_install_bun() {
	echo -e "${BLUE}检查 bun 是否已安装...${NC}"
	if command -v bun &>/dev/null; then
		echo -e "${GREEN}✓ bun 已安装: $(bun --version)${NC}"
		return 0
	fi

	echo -e "${YELLOW}bun 未安装，正在使用 npm 全局安装 bun...${NC}"
	if command -v npm &>/dev/null; then
		npm install -g bun
		if command -v bun &>/dev/null; then
			echo -e "${GREEN}✓ bun 安装成功: $(bun --version)${NC}"
			return 0
		else
			echo -e "${RED}✗ bun 安装失败${NC}"
			return 1
		fi
	else
		echo -e "${RED}✗ npm 未安装，无法安装 bun${NC}"
		return 1
	fi
}

# 安装 cli-lsp-client
install_cli_lsp_client() {
	local cli_lsp_dir="$SCRIPT_DIR/cli-lsp-client"

	if [ ! -d "$cli_lsp_dir" ]; then
		echo -e "${YELLOW}cli-lsp-client 目录不存在，跳过安装${NC}"
		return 0
	fi

	# 检查 cli-lsp-client 是否已经安装
	if command -v cli-lsp-client &>/dev/null; then
		echo -e "${GREEN}✓ cli-lsp-client 已安装: $(cli-lsp-client --version 2>/dev/null || echo 'version unknown')${NC}"
		return 0
	fi

	# 检查 node_modules 是否存在（表示依赖已安装）
	if [ -d "$cli_lsp_dir/node_modules" ]; then
		echo -e "${GREEN}✓ cli-lsp-client 依赖已安装（node_modules 存在）${NC}"
		# 如果 cli-lsp-client 命令不可用，可能需要创建软链接
		if [ -f "$cli_lsp_dir/dist/cli.js" ]; then
			echo -e "${BLUE}cli-lsp-client 命令不可用，创建软链接...${NC}"
			ln -sf "$cli_lsp_dir/dist/cli.js" /usr/local/bin/cli-lsp-client 2>/dev/null ||
				ln -sf "$cli_lsp_dir/dist/cli.js" "$HOME/.local/bin/cli-lsp-client" 2>/dev/null ||
				echo -e "${YELLOW}无法创建软链接，请手动将 cli-lsp-client 添加到 PATH${NC}"
		fi
		return 0
	fi

	echo -e "${BLUE}安装 cli-lsp-client...${NC}"

	if [ -f "$cli_lsp_dir/install.sh" ]; then
		bash "$cli_lsp_dir/install.sh"
		if [ $? -eq 0 ]; then
			echo -e "${GREEN}✓ cli-lsp-client 安装成功${NC}"
		else
			echo -e "${RED}✗ cli-lsp-client 安装失败${NC}"
			return 1
		fi
	else
		echo -e "${RED}✗ cli-lsp-client/install.sh 不存在${NC}"
		return 1
	fi
}

# 检查并安装 rust-analyzer
check_and_install_rust_analyzer() {
	echo -e "${BLUE}检查 rust-analyzer (LSP 工具)...${NC}"

	if command -v rust-analyzer &>/dev/null; then
		echo -e "${GREEN}✓ rust-analyzer 已安装${NC}"
		return 0
	fi

	echo -e "${YELLOW}✗ rust-analyzer 未安装${NC}"

	# 检查是否存在 Rust 开发环境
	if command -v rustup &>/dev/null; then
		echo -e "${BLUE}检测到 Rust 开发环境 (rustup)${NC}"
		echo -e "${BLUE}是否要安装 rust-analyzer? (y/n)${NC}"
		read -p "选择: " choice

		if [[ "$choice" =~ ^[Yy]$ ]]; then
			echo -e "${BLUE}正在安装 rust-analyzer...${NC}"
			rustup component add rust-analyzer
			if command -v rust-analyzer &>/dev/null; then
				echo -e "${GREEN}✓ rust-analyzer 安装成功${NC}"
				return 0
			else
				echo -e "${RED}✗ rust-analyzer 安装失败${NC}"
				return 1
			fi
		else
			echo -e "${YELLOW}跳过 rust-analyzer 安装${NC}"
			return 0
		fi
	elif command -v cargo &>/dev/null; then
		echo -e "${BLUE}检测到 Rust 开发环境 (cargo)${NC}"
		echo -e "${YELLOW}建议使用 rustup 安装 rust-analyzer: rustup component add rust-analyzer${NC}"
		return 0
	else
		echo -e "${YELLOW}未检测到 Rust 开发环境，跳过 rust-analyzer 安装${NC}"
		return 0
	fi
}
# 检查和安装格式化工具
check_and_install_formatters() {
	local tools=(
		"black:Python"
		"shfmt:Shell"
		"gofmt:Go"
		"rustfmt:Rust"
	)
	local missing_tools=()

	echo -e "${BLUE}检查格式化工具...${NC}"

	for tool_info in "${tools[@]}"; do
		IFS=':' read -r tool language <<<"$tool_info"
		if command -v "$tool" &>/dev/null; then
			echo -e "${GREEN}✓ $tool ($language) 已安装${NC}"
		else
			echo -e "${YELLOW}✗ $tool ($language) 未安装${NC}"
			missing_tools+=("$tool:$language")
		fi
	done

	if [ ${#missing_tools[@]} -eq 0 ]; then
		echo -e "${GREEN}✓ 所有格式化工具已安装${NC}"
		return 0
	fi

	echo ""
	echo -e "${YELLOW}以下格式化工具未安装:${NC}"
	for i in "${!missing_tools[@]}"; do
		IFS=':' read -r tool language <<<"${missing_tools[$i]}"
		echo "  $((i + 1)). $tool ($language)"
	done

	echo ""
	echo -e "${BLUE}是否要安装这些工具? (可输入多个编号，用空格分隔，或输入 'all' 安装全部，输入 'n' 跳过)${NC}"
	read -p "选择: " choice

	if [[ "$choice" =~ ^[Nn]$ ]]; then
		echo -e "${YELLOW}跳过格式化工具安装${NC}"
		return 0
	fi

	if [[ "$choice" == "all" ]]; then
		for tool_info in "${missing_tools[@]}"; do
			IFS=':' read -r tool language <<<"$tool_info"
			install_formatter "$tool" "$language"
		done
	else
		for num in $choice; do
			if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#missing_tools[@]} ]; then
				index=$((num - 1))
				IFS=':' read -r tool language <<<"${missing_tools[$index]}"
				install_formatter "$tool" "$language"
			else
				echo -e "${RED}无效选择: $num${NC}"
			fi
		done
	fi
}

# 安装单个格式化工具

install_formatter() {

	local tool=

	local language=$2

	echo -e "${BLUE}安装 $tool ($language)...${NC}"

	case "$tool" in

	black)

		if command -v pip3 &>/dev/null; then

			pip3 install black

		elif command -v pip &>/dev/null; then

			pip install black

		else

			echo -e "${RED}✗ 未找到 pip/pip3，无法安装 black${NC}"

			return 1

		fi

		;;

	shfmt)

		if command -v go &>/dev/null; then

			go install mvdan.cc/sh/v3/cmd/shfmt@latest

		else

			echo -e "${RED}✗ 未找到 go，无法安装 shfmt${NC}"

			return 1

		fi

		;;

	gofmt)

		if command -v go &>/dev/null; then

			echo -e "${YELLOW}gofmt 通常随 Go 安装，已在系统中${NC}"

			return 0

		else

			echo -e "${YELLOW}未检测到 Go 开发环境，请安装 Go: https://golang.org/dl/${NC}"

			return 1

		fi

		;;

	rustfmt)

		if command -v rustup &>/dev/null; then

			rustup component add rustfmt

		elif command -v cargo &>/dev/null; then

			echo -e "${YELLOW}建议使用 rustup 安装 rustfmt: rustup component add rustfmt${NC}"

			return 1

		else

			echo -e "${YELLOW}未检测到 Rust 开发环境，跳过 rustfmt 安装${NC}"

			return 1

		fi

		;;

	esac

	if command -v "$tool" &>/dev/null; then

		echo -e "${GREEN}✓ $tool 安装成功${NC}"

	else

		echo -e "${RED}✗ $tool 安装失败${NC}"

		return 1

	fi

}

# 检查目录是否存在
check_dirs() {
	for dir in "${DIRS[@]}"; do
		if [ ! -d "$SCRIPT_DIR/$dir" ]; then
			echo -e "${RED}错误: 目录 $dir 不存在${NC}"
			exit 1
		fi
	done
}

# 复制目录函数
copy_dir() {
	local src_dir=$1
	local dest_dir=$2
	local dir_name=$3

	if [ ! -d "$dest_dir" ]; then
		echo -e "${YELLOW}创建目录: $dest_dir${NC}"
		mkdir -p "$dest_dir"
	fi

	echo -e "${GREEN}复制 $dir_name 到 $dest_dir${NC}"
	cp -r "$src_dir"/* "$dest_dir/" 2>/dev/null || true
}

# 更新 settings.json 函数
update_settings() {
	local settings_file=$1

	# 如果 settings.json 不存在，创建一个空的
	if [ ! -f "$settings_file" ]; then
		echo "{}" >"$settings_file"
	fi

	# 检查是否已经包含 hooks 配置
	if grep -q '"hooks"' "$settings_file" 2>/dev/null; then
		echo -e "${YELLOW}settings.json 已包含 hooks 配置，跳过更新${NC}"
		return
	fi

	# 读取现有内容并添加 hooks 配置
	local temp_file=$(mktemp)
	local hooks_config='{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume",
        "hooks": [
          {
            "type": "command",
            "command": "cli-lsp-client start",
            "timeout": 30
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "cli-lsp-client iflow-cli-hook",
            "timeout": 30
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "cli-lsp-client iflow-cli-hook",
            "timeout": 30
          },
          {
            "type": "command",
            "command": "bash script/auto-format.sh"
          }
        ]
      }
    ]
  }
}'

	# 使用 jq 合并 JSON，如果没有 jq 则使用简单的字符串处理
	if command -v jq &>/dev/null; then
		jq --argjson hooks "$hooks_config" '. * $hooks' "$settings_file" >"$temp_file"
		mv "$temp_file" "$settings_file"
	else
		# 简单处理：将 hooks_config 追加到现有 JSON
		echo "$hooks_config" >"$temp_file"
		# 这里简化处理，实际应该合并 JSON 对象
		echo -e "${YELLOW}警告: 未安装 jq，settings.json 可能需要手动合并${NC}"
		echo -e "${GREEN}请将以下内容添加到 $settings_file:${NC}"
		echo "$hooks_config"
	fi

	echo -e "${GREEN}✓ 已更新 settings.json${NC}"
}

# 显示帮助信息
show_help() {
	cat <<EOF
iFlow CLI 安装脚本

用法:
    bash install.sh [选项]

选项:
    -g, --global     全局安装到 ~/.iflow
    -l, --local      本地安装到当前目录下的 .iflow
    -h, --help       显示此帮助信息

示例:
    bash install.sh --global   # 全局安装
    bash install.sh --local    # 本地安装
EOF
}

# 主安装函数
install() {
	local install_type=$1
	local base_dir

	if [ "$install_type" = "global" ]; then
		base_dir="$HOME/.iflow"
		echo -e "${GREEN}开始全局安装到 $base_dir${NC}"
	else
		base_dir="$SCRIPT_DIR/.iflow"
		echo -e "${GREEN}开始本地安装到 $base_dir${NC}"
	fi

	# 1. 检查并安装 bun
	check_and_install_bun || {
		echo -e "${RED}✗ bun 安装失败，终止安装${NC}"
		exit 1
	}

	# 2. 安装 cli-lsp-client
	install_cli_lsp_client || {
		echo -e "${YELLOW}cli-lsp-client 安装失败，继续安装其他组件${NC}"
	}

	# 2.5. 检查并安装 rust-analyzer
	check_and_install_rust_analyzer
	# 3. 检查和安装格式化工具
	check_and_install_formatters

	# 4. 检查源目录
	check_dirs

	# 5. 复制各个目录
	for dir in "${DIRS[@]}"; do
		copy_dir "$SCRIPT_DIR/$dir" "$base_dir/$dir" "$dir"
	done

	# 6. 更新 settings.json
	update_settings "$base_dir/settings.json"

	echo -e "${GREEN}✓ 安装完成！${NC}"
	echo -e "安装位置: $base_dir"
}

# 解析命令行参数
if [ $# -eq 0 ]; then
	show_help
	exit 0
fi

case "$1" in
-g | --global)
	install "global"
	;;
-l | --local)
	install "local"
	;;
-h | --help)
	show_help
	;;
*)
	echo -e "${RED}错误: 未知选项 '$1'${NC}"
	show_help
	exit 1
	;;
esac
