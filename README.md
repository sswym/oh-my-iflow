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

# 📖 简介

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

# 🚀 快速开始
## 安装

```bash 
git clone https://github.com/sswym/oh-my-iflow.git
cd oh-my-iflow
bash install.sh --local # 在当前目录下安装（推荐）
bash install.sh --global # 全局安装
```



🤝 贡献

欢迎贡献！请随时提交 Pull Request 或创建 Issue。
📄 许可证

本项目基于 oh-my-gemini-cli 修改，采用 MIT 许可证。
🙏 致谢

感谢 oh-my-gemini-cli 项目提供的优秀基础。
