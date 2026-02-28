<div align="center">

# oh-my-iflow(omi)

**基于多智能体工作流的智能命令行工具**

---

## 📖 简介

iFLOW CLI 的强化插件，由 [oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli) 修改而成，集成到 iFLOW 生态系统中。提供了一套完整的多智能体工作流层，帮助开发者更高效地进行代码编写、调试、规划和验证。

## ✨ 核心特性

### 🤖 多智能体协作

oh-my-iflow采用角色化的智能体架构，每个智能体专注于特定领域：

- **omi-architect** - 架构设计与权衡分析
- **omi-planner** - 任务分解与依赖映射
- **omi-product** - PRD 级别的范围界定与验收标准
- **omi-executor** - 代码实现与重构
- **omi-reviewer** - 代码审查与质量检查
- **omi-verifier** - 验证测试与回归检查
- **omi-debugger** - 问题诊断与修复
- **omi-researcher** - 技术研究与信息收集

### 🔄 完整的工作流管道

```
team-plan → team-prd → team-exec → team-verify → team-fix
```

通过结构化的阶段管道，确保每个任务都经过完整的规划、执行和验证周期。

### 🎯 多种操作模式

- **balanced** - 默认模式，平衡质量与速度
- **speed** - 快速执行，适用于简单任务
- **deep** - 深度设计，严格验证
- **autopilot** - 自主多阶段执行
- **ralph** - 严格质量门控
- **ultrawork** - 高吞吐量批处理模式

### 💾 持久化状态管理

自动维护项目状态，包括：
- 工作流状态
- 检查点记录
- 持久化内存 (MEMORY.md)
- 规则包管理
- 项目映射

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/your-username/oh-my-iflow.git
cd oh-my-iflow

# 确保已安装 iFLOW CLI
# 将项目配置添加到 iFLOW CLI 中
```

### 基本使用

#### 1. 启动团队协作模式

```bash
/omi:team 实现用户认证功能
```

这会触发完整的工作流管道，自动进行规划、执行和验证。

#### 2. 自动驾驶模式

```bash
/omi:autopilot 添加 API 端点并编写测试
```

自主执行多阶段循环，直到验收标准通过或遇到阻塞。

#### 3. 切换操作模式

```bash
/omi:mode deep
```

切换到深度模式，获得更严格的设计和验证。

#### 4. 意图分类

```bash
/omi:intent 需要重构这个模块
```

自动分类请求意图并推荐正确的处理路径。

#### 5. 内存管理

```bash
/omi:memory
```

审计并管理项目的持久化记忆和规则包。

## 📁 项目结构

```
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
```

## 🎯 核心原则

1. **保持前缀稳定** - 避免在会话中重写静态指令
2. **先规划后编码** - 对非平凡任务使用规划→执行→审查流程
3. **按角色委托** - 使用专门的智能体处理不同阶段
4. **最小化上下文负载** - 只读取当前步骤需要的文件
5. **始终以验证结束** - 运行相关测试和检查
6. **意图门控** - 在范围不明确时分类意图再执行
7. **循环纪律** - 对未完成的工作使用循环保持

## 🔧 高级功能

### 规则包管理

使用规则包为特定文件类型或项目区域定义自动化规则：

```bash
/omi:rules
```

规则包支持：
- 始终应用 (alwaysApply)
- 基于文件模式匹配 (globs)
- 条件激活

### 深度初始化

为长时间会话进行一次性深度仓库映射：

```bash
/omi:deep-init
```

### 循环执行

强制重复 exec-verify-fix 循环直到通过验收标准：

```bash
/omi:loop
```

### 状态显示

使用 HUD 控制状态显示的详细程度：

```bash
/omi:hud on      # 正常模式
/omi:hud compact # 紧凑模式
/omi:hud off     # 关闭显示
```

## 📊 工作流状态

在文件系统可用时会持久化以下状态：

- `.omi/state/mode.json` - 当前操作模式
- `.omi/state/workflow.md` - 工作流状态
- `.omi/state/checkpoint.md` - 检查点记录
- `MEMORY.md` - 持久化记忆索引
- `.omi/memory/*.md` - 主题文件
- `.omi/rules/*.md` - 规则包
- `.omi/state/intent.md` - 意图分类结果
- `.omi/state/validation.md` - 验证结果

## 🛡️ 安全保障

- 从不声称完成而不列出验证内容
- 从不在循环状态为 continue 或存在未解决阻塞时声称完成
- 在遇到缺失需求、权限或重复失败时停止自主循环
- 默认最大自主循环次数：5（除非用户要求不同）

## 🤝 贡献

欢迎贡献！请随时提交 Pull Request 或创建 Issue。

## 📄 许可证

本项目基于 [oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli) 修改，采用 MIT 许可证。

## 🙏 致谢

感谢 [oh-my-gemini-cli](https://github.com/Joonghyun-Lee-Frieren/oh-my-gemini-cli) 项目提供的优秀基础。
