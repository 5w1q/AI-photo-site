#!/bin/bash

# 添加所有更改的文件到暂存区
git add .

# 提交更改，包含日期和时间，便于区分
commit_message="Update HTML files: $(date)"
git commit -m "$commit_message"

# 推送到 GitHub
git push origin main

# 提示用户
echo "HTML files have been successfully pushed to GitHub!"
