# 执行步骤与验收清单

## 单批次执行步骤
1. 只领取一个批次，确保文件集合不和其他人重叠。
2. 严格按 [02_parallel_batches.md](C:/Users/jiang/code/zed/chinese/02_parallel_batches.md) 中的文件顺序处理。
3. 每个文件只搜索并替换静态 UI 字符串。
4. 每改完一个文件，先做一次最小自检，再继续下一个文件。
5. 一个批次完成后，再做一次批次级 diff 审核。

## 单文件修改方法
每个文件都按下面的顺序处理：

1. 搜索这些调用点：
   - `Label::new("`
   - `Button::new(`
   - `Tooltip::text("`
   - `ContextMenuEntry::new("`
   - `set_placeholder_text("`
   - `window.prompt(`
   - `.label("`
   - `.title("`
   - `.description("`
   - `.empty_message("`
   - `MenuItem::action("`
2. 只翻译这些调用点中直接写死的英文字符串。
3. 如果字符串里包含产品名、文件名、代码片段、配置文件名，只翻译外围自然语言，不翻译这些技术标识。
4. 如果同一个文件里同一动作有多处重复字符串，统一译法。

## 单文件禁止项
- 不改 `format!`
- 不改 `context("...")`
- 不改 `anyhow!` / `bail!`
- 不改 `log::...`
- 不改注释
- 不改测试
- 不改任何变量名、函数名、结构体字段名
- 不改任何行为分支

## 推荐翻译一致性
- Save -> 保存
- Cancel -> 取消
- Close -> 关闭
- Dismiss -> 关闭
- Delete -> 删除
- Remove -> 移除
- Restore -> 恢复
- Retry -> 重试
- Configure -> 配置
- Learn More -> 了解更多
- Sign In -> 登录
- Open -> 打开
- New Window -> 新建窗口
- Search -> 搜索

## 推荐自检命令
每个批次完成后建议执行：

```powershell
git diff --word-diff
```

```powershell
git diff --unified=0
```

```powershell
git diff --name-only
```

检查点：

- 改动文件必须只落在当前批次文件列表内
- diff 中不应出现逻辑代码改动
- diff 中不应出现测试文件
- diff 中不应出现文档文件

## 批次级验收
- 文件列表完整处理完毕
- 同批次内术语统一
- 没有误改动态字符串
- 没有误改注释、测试、文档
- 共享组件类文件改动前后术语已和其他批次对齐

## 合并顺序建议
推荐合并顺序：

1. `B11`
2. `B01`
3. `B02`
4. `B03`
5. `B04`
6. `B05`
7. `B06`
8. `B07`
9. `B08`
10. `B09`
11. `B10`

原因：

- 共享组件和主框架先稳定
- 壳层与导航类改动先落地
- 业务面板和 Agent 大批量改动后合并
- Provider 设置界面最后合并，便于统一术语

## 最终总验收
全部批次完成后，再统一做一次全仓检查：

- 只改了 136 个计划文件中的一部分或全部
- 没有任何文档文件改动
- 没有任何测试文件改动
- 没有任何逻辑变更
- 所有改动均为 UI 静态字符串替换

