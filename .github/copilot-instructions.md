# Copilot Instructions

## Style Guide

### Python

- Follow [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- Ensure consistency with PEP 8 where applicable
- Use `black` for auto-formatting (`black --line-length 128` recommended)
- Use `pylint` for linting

### BigQuery

#### SQL Version

Use StandardSQL, LegacySQL is prohibited.

#### Uppercase and Lowercase Usage

- **SQL Keywords (Reserved Words)**: Uppercase
- **Function Names**: Uppercase
- **Table and Column Names**: Lowercase

#### Handling Commas

- Since GitHub diff is line-based, **always include a comma after the last column in `SELECT` lists and queries**.
- For clauses other than `SELECT` (such as `GROUP BY`, `ORDER BY`), **exclude a comma after the last element** (do not add a trailing comma).

**Example:**

```sql
SELECT
  id,
  column_name,
  created_at,       -- Include comma
FROM users
GROUP BY
  id,
  column_name,
  created_at        -- Exclude comma
ORDER BY
  created_at DESC   -- Exclude comma
```

#### Alias AS Clause

- Do not omit (always explicitly write AS).

#### `OUTER` for `JOIN`

- Omit `OUTER` (a `LEFT JOIN` or `RIGHT JOIN` is sufficiently clear).

#### Writing Binary Operators

- Include spaces before and after operators.

#### String Literals

- Use single quotes `'` (recommended by BigQuery).
- Use double quotes `"` for escaping identifiers.
- When using `FORMAT` functions, utilize `CAST`.

#### Comments

- Single-line comments: Use `--` (avoid using `#`)
- Multi-line comments: Use `/* ... */` and align the beginning of each line

#### Line Breaks and Indentation

- Use **2 spaces** for indentation for most queries.
- Use **4 spaces** for more complex queries (e.g., nested queries or deep joins).
- **Do not use tabs** for indentation.
- For complex list structures (`STRUCT`, `ARRAY`, `IF`), break lines for each element.
- For subqueries or `WITH` clauses, break lines for each element to avoid deep nesting.
- Always break lines for `JOIN`, and write conditions on the line following `ON`.
- Align `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`, and `HAVING` clauses for better readability.

**Example:**

```sql
WITH user_data AS (
  SELECT
    id,
    name,
    created_at
  FROM users
)
SELECT
  u.id,
  u.name,
  o.order_id
FROM users AS u
INNER JOIN orders AS o
  ON u.id = o.user_id
WHERE created_at >= '2022-01-01'
GROUP BY
  id,
  name
ORDER BY
  created_at DESC;
```

#### Subqueries

- Prefer `WITH` clauses with meaningful names.
- Avoid subqueries longer than 6 lines.
- Create `VIEW` or `TABLE` for reusable queries.

#### Table Aliases

- Use the table name directly if it is 8 characters or fewer.
- For table names longer than 8 characters, define an alias.
- When self-joining, assign meaningful aliases:
  - **Base table**: `base`
  - **Joined table**: `joined`
  - **Supplementary info table**: Use `_info` (e.g., `user_info`).

**Example:**

```sql
SELECT
  u1.id AS current_user,
  u2.id AS previous_user
FROM users AS u1
LEFT JOIN users AS u2
  ON u1.referrer_id = u2.id;
```

#### Time Zones and Date Types

- Prefer `TIMESTAMP` and specify the time zone explicitly.
- When using `DATETIME`, explicitly specify `JST` or `UTC`.
- Avoid implicit time zone conversions.
- When using `CURRENT_TIMESTAMP()`, use `AT TIME ZONE` for intentional conversions.

**Example:**

```sql
SELECT
  CURRENT_TIMESTAMP() AT TIME ZONE 'Asia/Tokyo' AS jst_time
```

#### Table Naming Conventions

##### Prefixes by Meaning Group

- Use consistent prefixes for tables used together.
- Avoid meaningless prefixes.

##### Date Suffixes

- For daily backup tables, use `_yyyyMMdd`.
- Do not use shortened forms like `_yyMMdd`.

### Markdown

#### General Formatting

- Use `#` for headings and ensure proper hierarchy (e.g., `#`, `##`, `###`).
- Leave a blank line before and after headings, lists, and code blocks.
- Use `-` for unordered lists and `1.` for ordered lists.
- Limit line length to 80 characters for better readability.

#### Code Blocks

- Use triple backticks (\`\`\`) for code blocks.
- Specify the language for syntax highlighting (e.g., `\`\`\`python`, `\`\`\`sql`).
- For inline code, use single backticks (\`code\`).

#### Links

- Use descriptive text for links, avoiding raw URLs.
- Example: `[Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)`.

#### Images

- Use the following format for images:

  ```markdown
  ![Alt text](image_url "Optional title")
  ```

#### Tables

- Use pipes (`|`) to create tables and align columns for readability.
- Example:

  ```markdown
  | Column 1 | Column 2 |
  | -------- | -------- |
  | Value 1  | Value 2  |
  ```

#### Blockquotes

- Use `>` for blockquotes.
- Example:

  ```markdown
  > This is a blockquote.
  ```

#### Notes, Tips, and Warnings

- Use the following syntax for special callouts like notes, tips, and warnings:

  ```markdown
  > [!NOTE]
  > This is a note example.

  > [!TIP]
  > This is a tip example.

  > [!IMPORTANT]
  > This is an important example.

  > [!WARNING]
  > This is a warning example.

  > [!CAUTION]
  > This is a caution example.
  ```

#### Horizontal Rules

- Use three dashes (`---`) for horizontal rules.

#### Comments

- Use `<!-- -->` for comments in Markdown files.
- Example:

  ```markdown
  <!-- This is a comment -->
  ```

#### File Naming

- Use lowercase letters and hyphens (`-`) for file names.
- Avoid spaces or underscores.

#### Line Breaks

- Use two spaces at the end of a line for a soft break.
- Use a blank line for a hard break (new paragraph).

#### Lists

- Indent nested lists by two spaces.
- Example:

  ```markdown
  - Item 1
    - Subitem 1.1
    - Subitem 1.2
  ```

#### Emphasis

- Use `_` for italics and `**` for bold text.
- Example:

  ```markdown
  _italic_
  **bold**
  ```

#### Escaping Special Characters

- Use a backslash (`\`) to escape special characters (e.g., `\*`, `\#`).

#### Metadata

- Include metadata at the top of Markdown files when applicable.
- Example:

  ```markdown
  <!-- filepath: /path/to/file -->
  ```

## Visualization Guide

### 推奨パッケージ

| パッケージ   | 用途                       | 備考                                                             |
| ------------ | -------------------------- | ---------------------------------------------------------------- |
| `matplotlib` | 基本的なプロット           | 軽量・柔軟。`seaborn`と併用可                                    |
| `seaborn`    | 統計的なプロット           | `matplotlib`ベース、デフォルトテーマが視覚的に優れる             |
| `plotly`     | インタラクティブな可視化   | Web ベース、ダッシュボードとの親和性が高い                       |
| `altair`     | 宣言型の可視化             | `Vega-Lite` ベース。簡潔なコードで洗練された出力                 |
| `hvplot`     | 大規模データ対応           | `pandas`, `dask`, `xarray` と連携可。簡単なコードでプロット可能  |
| `holoviews`  | 高度な可視化フレームワーク | インタラクティブな可視化やカスタマイズに優れる。`hvplot`と併用可 |
| `bokeh`      | Web インタラクティブ       | サーバーサイドと連携可（ダッシュボード用途）                     |

### コーディングルール

- 可視化ロジックは関数化
- サブプロットで整列表示すること（例: `matplotlib.pyplot.subplots` で `nrows`/`ncols` を指定、または `matplotlib.gridspec.GridSpec` を使用）
- 軸・タイトル・凡例の明示は必須
- カラースキームはユニバーサルデザインを考慮し、`seaborn` を使用する場合は `sns.color_palette("colorblind")` を明示的に設定することを推奨

### タイトル・ラベルの命名ルール

- 英語表記
- タイトル：文頭のみ大文字 (Sales trend by region)
- 軸ラベル：単位はカッコで (Revenue (JPY))
- 凡例名：簡潔 (Actual, Forecast)

### スタイル設定（`matplotlib` / `seaborn`）

```python
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
plt.rcParams["axes.titlesize"] = 14
plt.rcParams["axes.labelsize"] = 12
plt.rcParams["xtick.labelsize"] = 10
plt.rcParams["ytick.labelsize"] = 10
plt.rcParams["legend.fontsize"] = 10
plt.rcParams["figure.figsize"] = (10, 6)
```

### サンプルコード（`seaborn`）

```python
import os

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

sns.set_theme(style="whitegrid")

def create_sales_by_region_plot(df: pd.DataFrame) -> plt.Figure:
    """Create a sales trend by region plot and return the Figure object."""
    fig, ax = plt.subplots(figsize=(10, 6))

    plot_title = "Sales trend by region"
    # Check dataset size and adjust markers or downsample if necessary
    if len(df) > 1000:  # Threshold for large datasets
        sns.lineplot(data=df.sample(1000, random_state=42), x="date", y="sales", hue="region", marker=None, ax=ax)
    else:
        sns.lineplot(data=df, x="date", y="sales", hue="region", marker="o", ax=ax)

    ax.set_title(plot_title)
    ax.set_xlabel("Date")
    ax.set_ylabel("Sales (JPY)")
    ax.legend(title="Region", loc="upper left")

    fig.tight_layout()
    return fig

# --- 呼び出し側のコード ---
# sales_df = pd.DataFrame(...) # データフレームを準備

# Figureオブジェクトを取得
# fig = create_sales_by_region_plot(sales_df)

# 表示する場合
# plt.show() # create_sales_by_region_plot内で plt.show() を呼ばない場合

# ファイルに保存する場合 (SVG形式)
# output_filename_svg = os.path.join(TASK_REPORT_DIR, "sales_trend_by_region.svg")
# fig.savefig(output_filename_svg, bbox_inches='tight')
# plt.close(fig) # メモリ解放
```

### その他の推奨事項

- Jupyter Notebook を利用する際は `%matplotlib inline` を明示する。
- カスタムフォントの使用は環境依存に注意し、可能な限り避けるか、代替手段を検討する。
- 画像をファイルとして保存する際は、`plt.savefig()` の `bbox_inches='tight'` オプションを利用して、余白を適切にトリミングする。
- 出力する画像ファイル名は、グラフタイトルを小文字のスネークケースに変換したものを基本とします (例: タイトルが "Sales trend by region" ならば `sales_trend_by_region`)。ただし、タイトルが非常に長い場合やファイル名として不適切な文字を含む場合は、内容を簡潔に表すように調整してください。
- ファイル拡張子は `.png` または `.svg` とします。SVG 形式は拡大縮小しても品質が劣化しないため、可能な場合は推奨されます。
- インタラクティブな可視化ライブラリ（`plotly`, `bokeh` など）を使用する場合、出力されるファイルのサイズや実行環境の依存関係に注意する。
- 可視化に使用したコード、主要なライブラリのバージョン情報は、再現性の観点から記録しておくことを推奨する。
- 色の参照元として、リポジトリ内の `.github/color_palette.md` を単一の参照元として使用してください。可視化や UI で使用する色はその一覧から選んで整合性を保ってください。
- 色覚多様性に配慮したカラーパレットの選択に加え、テキストと背景のコントラスト比、フォントサイズなど、視覚的なアクセシビリティ全般に配慮する。
