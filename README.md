# oh-my-iflow(omi)

## 基于多智能体工作流的智能命令行工具

- 当前仓库:[https://github.com/sswym/oh-my-iflow](https://github.com/sswym/oh-my-iflow)
- 上游仓库: [https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli)

---
## 更新
### 2026-03-12 架构优化与状态管理整改

基于深度分析报告实施的核心优化：

**高优先级 - 状态路径统一**
- 统一所有状态文件存储路径为 `.omi/state/`
- 修复了 6 个技能文件和 6 个命令文件中的状态路径引用
- 消除了 `.iflow/state/` 和 `.omi/state/` 混用的问题

**中优先级 - 循环配置集中化**
- 在 `context/omi-core.md` 添加全局配置定义
- 支持按模式配置循环限制（speed: 3, default: 5, deep: 10, autopilot: 5, ralph: -1）
- 更新 `loop` 和 `autopilot` 技能/命令使用集中配置

**新增工具**
- 添加 `script/state-utils.sh` 状态管理工具函数
- 支持 `init/read/write/config/loop-limit/status` 等命令

**变更文件清单**
```
skills/approval/SKILL.md      - 状态路径更新
skills/reasoning/SKILL.md     - 状态路径更新
skills/doctor/SKILL.md        - 状态路径更新
skills/loop/SKILL.md          - 循环配置引用更新
skills/autopilot/SKILL.md     - 循环配置引用更新
commands/omi/approval.toml    - 状态路径更新
commands/omi/reasoning.toml   - 状态路径更新
commands/omi/doctor.toml      - 状态路径更新
commands/omi/loop.toml        - 循环配置引用更新
commands/omi/autopilot.toml   - 循环配置引用更新
commands/omi/team-assemble.toml - 状态路径更新
context/omi-core.md           - 添加全局配置定义
script/state-utils.sh         - 新增状态管理工具
```

### 2026-03-06同步上游更新
```bash
/omi:team-assemble 请帮我完全复刻这个页面：https://cli.iflow.cn/?spm=3e711c3f.2ef5001f.0.0.3d8173e8mb1HSX
```
![](./images/sfgobsdnfa.png)
![](./images/aoifdrijginvfin.jpeg)

### 2026-03-06
- 优化安装脚本install.sh
- 删除lsp-mcp，采用[cli-lsp-cient](https://github.com/eli0shin/cli-lsp-client) 增加rust语言支持
- 增加python、rust、go、shell、以及前端语言文件的自动识别格式化功能。
![](./images/image.png)
![](./images/a1586990-63dd-45ec-be19-d536721f99ad.png)

---
- 添加lsp-mcp，添加python、go、rust等语言的lsp支持
- 添加一键安装脚本 install.sh 可选择全局安装与项目安装，安装前记得备份

同步oh-my-gemini-cli更新

    新增了扩展-原生钩子编排控制:
        /omi:hooks
        /omi:hooks-init
        /omi:hooks-validate
        /omi:hooks-test
        $hooks
    添加确定性挂钩通道(P0-safety,P1-quality,P2-optimization提供超时/减压/自付指导
    为长会话添加派生信号策略:
        context-drift
        risk-spike
        loop-stall
        token-burst
        blocker-repeat
    添加了 hook 运行状态约定:
        .omi/state/hooks.json
        .omi/state/hooks-validation.md
        .omi/state/hooks-last-test.md
        .omi/hooks/*.md

📖 简介

iFLOW CLI 的强化插件，由 oh-my-gemini-cli 修改而成，集成到 iFLOW 生态系统中。提供了一套完整的多智能体工作流层，帮助开发者更高效地进行代码编写、调试、规划和验证。
✨ 核心特性
🤖 多智能体协作

oh-my-iflow采用角色化的智能体架构，每个智能体专注于特定领域：

    omi-architect - 架构设计与权衡分析
    omi-planner - 任务分解与依赖映射
    omi-product - PRD 级别的范围界定与验收标准
    omi-executor - 代码实现与重构
    omi-reviewer - 代码审查与质量检查
    omi-verifier - 验证测试与回归检查
    omi-debugger - 问题诊断与修复
    omi-researcher - 技术研究与信息收集

🔄 完整的工作流管道

team-plan → team-prd → team-exec → team-verify → team-fix

通过结构化的阶段管道，确保每个任务都经过完整的规划、执行和验证周期。
🎯 多种操作模式

    balanced - 默认模式，平衡质量与速度
    speed - 快速执行，适用于简单任务
    deep - 深度设计，严格验证
    autopilot - 自主多阶段执行
    ralph - 严格质量门控
    ultrawork - 高吞吐量批处理模式

💾 持久化状态管理

自动维护项目状态，包括：

    工作流状态
    检查点记录
    持久化内存 (MEMORY.md)
    规则包管理
    项目映射

🚀 快速开始
安装

# 克隆仓库
git clone https://github.com/your-username/oh-my-iflow.git
cd oh-my-iflow

# 确保已安装 iFLOW CLI
# 将项目配置添加到 iFLOW CLI 中

安装前准备

    确保已安装 iFLOW CLI：oh-my-iflow 是 iFLOW CLI 的扩展插件，需要先安装 iFLOW CLI
    备份现有配置（可选但推荐）：如果你已经有 ~/.iflow 目录，建议先备份

    cp -r ~/.iflow ~/.iflow.backup

    安装依赖工具（可选）：
        jq：用于自动合并 JSON 配置（macOS: brew install jq，Ubuntu: apt-get install jq）

安装步骤
方式一：全局安装（推荐）

全局安装会将配置应用到 ~/.iflow 目录，所有项目都可以使用这些命令。

macOS / Linux:

# 1. 克隆仓库
git clone https://github.com/hubo1989/oh-my-iflow.git
cd oh-my-iflow

# 2. 执行全局安装脚本
bash install.sh --global

# 3. 验证安装
ls ~/.iflow/commands/omi/

Windows (PowerShell):

# 1. 克隆仓库
git clone https://github.com/hubo1989/oh-my-iflow.git
cd oh-my-iflow

# 2. 手动复制目录到用户目录
# 注意：Windows 需要使用手动安装方式（见下方）

方式二：本地安装

本地安装会将配置应用到当前项目的 .iflow 目录，仅当前项目可用。

macOS / Linux:

# 1. 克隆仓库到项目目录（或复制 install.sh 到项目）
git clone https://github.com/hubo1989/oh-my-iflow.git /tmp/oh-my-iflow

# 2. 在项目根目录执行本地安装
cd /path/to/your/project
bash /tmp/oh-my-iflow/install.sh --local

# 3. 验证安装
ls .iflow/commands/omi/

方式三：手动安装（适用于所有系统）

如果自动安装脚本无法运行，可以手动复制文件：

macOS / Linux:

# 1. 克隆仓库
git clone https://github.com/hubo1989/oh-my-iflow.git
cd oh-my-iflow

# 2. 创建目标目录
mkdir -p ~/.iflow

# 3. 复制所有目录
cp -r agents ~/.iflow/
cp -r commands ~/.iflow/
cp -r context ~/.iflow/
cp -r skills ~/.iflow/
cp -r mcp ~/.iflow/

# 4. 手动添加 MCP 配置到 ~/.iflow/settings.json（如果不存在）
# 配置内容参考 install.sh 中的 mcp_config 变量

Windows (手动安装):

# 1. 克隆仓库
git clone https://github.com/hubo1989/oh-my-iflow.git
cd oh-my-iflow

# 2. 创建目标目录
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.iflow"

# 3. 复制所有目录
Copy-Item -Recurse -Force agents "$env:USERPROFILE\.iflow\"
Copy-Item -Recurse -Force commands "$env:USERPROFILE\.iflow\"
Copy-Item -Recurse -Force context "$env:USERPROFILE\.iflow\"
Copy-Item -Recurse -Force skills "$env:USERPROFILE\.iflow\"
Copy-Item -Recurse -Force mcp "$env:USERPROFILE\.iflow\"

# 4. 手动编辑 settings.json 添加 MCP 配置

安装验证

安装完成后，可以通过以下方式验证：

# 1. 检查目录结构
ls ~/.iflow/commands/omi/  # 应该看到 team.toml, autopilot.toml 等文件

# 2. 检查智能体配置
ls ~/.iflow/agents/  # 应该看到 architect.md, planner.md 等文件

# 3. 在 iFLOW CLI 中测试命令
# 启动 iFLOW CLI 后，输入以下命令测试：
# /omi:status
# /omi:team 测试任务

卸载

如果需要卸载：

# 全局安装卸载
rm -rf ~/.iflow/agents
rm -rf ~/.iflow/commands
rm -rf ~/.iflow/context
rm -rf ~/.iflow/skills
rm -rf ~/.iflow/mcp

# 本地安装卸载
rm -rf .iflow

基本使用
1. 启动团队协作模式

/omi:team 实现用户认证功能

这会触发完整的工作流管道，自动进行规划、执行和验证。
2. 自动驾驶模式

/omi:autopilot 添加 API 端点并编写测试

自主执行多阶段循环，直到验收标准通过或遇到阻塞。
3. 切换操作模式

/omi:mode deep

切换到深度模式，获得更严格的设计和验证。
4. 意图分类

/omi:intent 需要重构这个模块

自动分类请求意图并推荐正确的处理路径。
5. 内存管理

/omi:memory

审计并管理项目的持久化记忆和规则包。
📁 项目结构

oh-my-iflow/
├── agents/              # 智能体配置
│   ├── architect.md     # 架构师智能体
│   ├── planner.md       # 规划师智能体
│   ├── product.md       # 产品经理智能体
│   ├── executor.md      # 执行者智能体
│   ├── reviewer.md      # 审查者智能体
│   ├── verifier.md      # 验证者智能体
│   ├── debugger.md      # 调试者智能体
│   └── researcher.md    # 研究者智能体
├── commands/omi/        # 命令配置
│   ├── team.toml        # 团队协作命令
│   ├── autopilot.toml   # 自动驾驶命令
│   ├── mode.toml        # 模式切换命令
│   ├── intent.toml      # 意图分类命令
│   ├── memory.toml      # 内存管理命令
│   └── ...
├── skills/              # 技能模块
│   ├── team/            # 团队协作技能
│   ├── autopilot/       # 自动驾驶技能
│   ├── loop/            # 循环执行技能
│   ├── memory/          # 内存管理技能
│   ├── intent/          # 意图分类技能
│   └── ...
└── context/             # 核心上下文
    └── omi-core.md      # omi 核心配置

🎯 核心原则

    保持前缀稳定 - 避免在会话中重写静态指令
    先规划后编码 - 对非平凡任务使用规划→执行→审查流程
    按角色委托 - 使用专门的智能体处理不同阶段
    最小化上下文负载 - 只读取当前步骤需要的文件
    始终以验证结束 - 运行相关测试和检查
    意图门控 - 在范围不明确时分类意图再执行
    循环纪律 - 对未完成的工作使用循环保持

🔧 高级功能
规则包管理

使用规则包为特定文件类型或项目区域定义自动化规则：

/omi:rules

规则包支持：

    始终应用 (alwaysApply)
    基于文件模式匹配 (globs)
    条件激活

深度初始化

为长时间会话进行一次性深度仓库映射：

/omi:deep-init

循环执行

强制重复 exec-verify-fix 循环直到通过验收标准：

/omi:loop

状态显示

使用 HUD 控制状态显示的详细程度：

/omi:hud on      # 正常模式
/omi:hud compact # 紧凑模式
/omi:hud off     # 关闭显示

📊 工作流状态

在文件系统可用时会持久化以下状态：

    .omi/state/mode.json - 当前操作模式
    .omi/state/workflow.md - 工作流状态
    .omi/state/checkpoint.md - 检查点记录
    MEMORY.md - 持久化记忆索引
    .omi/memory/*.md - 主题文件
    .omi/rules/*.md - 规则包
    .omi/state/intent.md - 意图分类结果
    .omi/state/validation.md - 验证结果

🛡️ 安全保障

    从不声称完成而不列出验证内容
    从不在循环状态为 continue 或存在未解决阻塞时声称完成
    在遇到缺失需求、权限或重复失败时停止自主循环
    默认最大自主循环次数：5（除非用户要求不同）

🤝 贡献

欢迎贡献！请随时提交 Pull Request 或创建 Issue。
📄 许可证

本项目基于 oh-my-gemini-cli 修改，采用 MIT 许可证。
🙏 致谢

感谢 oh-my-gemini-cli 项目提供的优秀基础。