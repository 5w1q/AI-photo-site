#!/usr/bin/env bash

# 自动分批上传 images 目录中未跟踪的 mp4 文件

set -e  # 任意一步出错就停止

# 确保在仓库根目录运行
if [ ! -d ".git" ]; then
  echo "请在 Git 仓库根目录运行（例如 /f/AI-Photo-Site）"
  exit 1
fi

echo "开始扫描 images 目录中的未上传 mp4 文件..."

# 遍历 images 目录下的所有 mp4
for f in images/*.mp4; do
  # 如果通配符没有匹配到文件，会返回字面量 'images/*.mp4'，需要跳过
  if [ "$f" = "images/*.mp4" ]; then
    echo "未找到任何 mp4 文件，结束。"
    exit 0
  fi

  # 检查这个文件是否是“未跟踪”或“已修改”，不是的话就跳过
  status=$(git status --porcelain -- "$f")

  if [ -z "$status" ]; then
    echo "已跳过：$f （已在 Git 中，无需上传）"
    continue
  fi

  # 只处理未跟踪（??）或已修改（ M）状态的文件
  echo "$status" | grep -E '^\?\?|^ M' >/dev/null 2>&1 || {
    echo "已跳过：$f （状态：$status）"
    continue
  }

  echo "----------------------------------------"
  echo "正在上传：$f"

  git add "$f"
  git commit -m "add $(basename "$f")"
  git push

  echo "完成上传：$f"
  echo
done

echo "所有待上传的 mp4 文件已处理完毕。"
