import subprocess
from pathlib import Path

# 你仓库在 Gitee 上的信息
OWNER = "wang-zongyu-Ab"
REPO = "AI-Photo-Site"
BRANCH = "main"

RAW_BASE = f"https://gitee.com/{OWNER}/{REPO}/raw/{BRANCH}/"

# 调用 git ls-files，列出当前仓库所有已跟踪的文件
result = subprocess.run(
    ["git", "ls-files"],
    capture_output=True,
    text=True,
    check=True
)

paths = [line.strip() for line in result.stdout.splitlines()]

# 只保留 images/ 和 files/ 下的文件
paths = [p for p in paths if p.startswith("images/") or p.startswith("files/")]

image_exts = {".png", ".jpg", ".jpeg", ".gif", ".webp"}
video_exts = {".mp4", ".mov", ".webm"}

images = []
videos = []
others = []

for p in paths:
    ext = Path(p).suffix.lower()
    url = RAW_BASE + p

    if ext in image_exts:
        images.append((p, url))
    elif ext in video_exts:
        videos.append((p, url))
    else:
        others.append((p, url))

# 生成纯链接列表
with open("raw_links.txt", "w", encoding="utf-8") as f:
    def write_block(title, items):
        f.write(f"## {title}\n")
        for rel, url in items:
            f.write(f"{rel}\n    {url}\n")
        f.write("\n")

    write_block("Images", images)
    write_block("Videos", videos)
    write_block("Others (json/zip/etc.)", others)

print("已生成 raw_links.txt")

# 生成适合直接拷贝进 HTML 的示例
with open("raw_links_for_html.txt", "w", encoding="utf-8") as f:
    f.write("### 图片 <img> 示例\n\n")
    for rel, url in images:
        f.write(f'<!-- {rel} -->\n')
        f.write(f'<img src="{url}" alt="{rel}" />\n\n')

    f.write("\n### 视频 <video> 示例\n\n")
    for rel, url in videos:
        f.write(f'<!-- {rel} -->\n')
        f.write(f'<video src="{url}" controls></video>\n\n')

    f.write("\n### 其它文件 <a> 下载链接示例\n\n")
    for rel, url in others:
        f.write(f'<!-- {rel} -->\n')
        f.write(f'<a href="{url}" download>{rel}</a>\n\n')

print("已生成 raw_links_for_html.txt")

