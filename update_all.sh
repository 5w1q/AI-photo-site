#!/usr/bin/env bash

# 一键更新脚本：
# 1. 提交并推送非 mp4 的所有改动（小文件）
# 2. 再调用 upload_mp4.sh 自动分批上传视频

set -e  # 任意一步出错就停止

# 检查是否在 Git 仓库根目录
if [ ! -d ".git" ]; then
  echo "当前目录不是 Git 仓库根目录，请在 /f/AI-Photo-Site 里运行。"
  exit 1
fi

echo "=== 第一步：提交并推送小文件（不包含 mp4） ==="

# 先把所有改动加入暂存区
git add .

# 把 images 目录里的 mp4 从暂存区移除（避免和小文件一起打包）
git reset HEAD images/*.mp4 2>/dev/null || true

# 如果没有小文件的改动，就不提交
if git diff --cached --quiet; then
  echo "没有需要提交的小文件改动，跳过提交。"
else
  git commit -m "update site (small files)"
  git push
fi

echo
echo "=== 第二步：分批上传 mp4 视频（调用 upload_mp4.sh） ==="

if [ -x "./upload_mp4.sh" ]; then
  ./upload_mp4.sh
else
  echo "未找到可执行的 upload_mp4.sh，跳过视频上传。"
  echo "如需上传视频，请先创建并 chmod +x upload_mp4.sh。"
fi

echo
echo "=== 完成：小文件 + 视频 已处理完毕 ==="
