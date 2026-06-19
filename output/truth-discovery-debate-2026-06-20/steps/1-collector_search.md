# 步骤 1/7: collector_search（话题搜集者）

## 话题搜集报告

### 搜集范围

- 默认领域：古代作者品牌化、经典文本归属、语料库传承。
- 本地依据：`tests/scenarios/truth-discovery-author-brand.md`、`skills/truth-discovery/cases/aristotle-brand-corpus.md`。
- 外部线索：Stanford Encyclopedia of Philosophy 的 `The Textual Transmission of the Aristotelian Corpus` 条目；另有 Aristotle corpus、Hippocratic corpus、古希腊修辞文本归属争议等相关材料。

### 候选话题

#### 候选 1：亚里士多德语料库是否是后世品牌化的混合语料库

- 争议背景：现存 Corpus Aristotelicum 包含讲义、学生材料、后世编订和疑伪作品；Andronicus of Rhodes 编订、Diogenes Laertius 与 Hesychius 书目列表、Nicomachean/Eudemian Ethics 共同书卷等都显示归属链复杂。
- 核心争议点：历史人物、核心思想、讲义材料、学派整理、后世教材神话之间应如何分层判断。
- 审核评分：争议性 5/5，可验证性 4/5，分层空间 5/5，知识价值 5/5，红旗密度 5/5，总分 24/25。
- 是否入选：是。

#### 候选 2：Hippocratic Corpus 是否是医学学派品牌而非单一作者作品

- 争议背景：Hippocrates 名下医学文本长期被视为混合语料库，早期 Hellenistic collection 与后世注释传统均存在归属不确定性。
- 核心争议点：历史医师、医学传统、文本集合和后世医学权威之间的关系。
- 审核评分：争议性 5/5，可验证性 4/5，分层空间 5/5，知识价值 4/5，红旗密度 4/5，总分 22/25。
- 是否入选：备选。

#### 候选 3：Pseudo-Dionysian Ars Rhetorica 的归属与古代修辞语料库整理机制

- 争议背景：古代修辞文本存在作者、年代和语境争议，现代计算文体学尝试介入鉴别。
- 核心争议点：传统文献学与机器作者归属方法如何共同处理古代文本。
- 审核评分：争议性 4/5，可验证性 3/5，分层空间 4/5，知识价值 4/5，红旗密度 4/5，总分 19/25。
- 是否入选：备选。

### 入选话题

最终选定候选 1。理由：它直接对应本仓库当前优先级“古代作者品牌化 → 分层真相判断”，已有本地案例和测试场景，同时具备外部可核查材料，适合检验 agents → skill 自我迭代闭环。

### 话题精炼

- 原始表述：亚里士多德是否真的写了那么多跨领域著作，还是后世学派、编者、宗教/教育机构共同制造的作者品牌？
- 精炼表述：现存亚里士多德语料库应被如何分层归属：历史个体、学园讲义、学生/学派材料、后世编订语料库、权威品牌和教材神话各占多大比例？
