#!/bin/bash

# 显示当前状态
echo "Checking status..."
git status

# 添加所有更改的文件到 Git 暂存区
echo "Adding changes to staging area..."
git add .

# 提交更改，包含日期和时间，便于区分
commit_message="Sync changes: $(date)"
echo "Committing changes with message: $commit_message"
git commit -m "$commit_message"

# 推送更改到 GitHub
echo "Pushing changes to GitHub..."
git push origin main

# 显示推送结果
if [ $? -eq 0 ]; then
    echo "Changes have been successfully pushed to GitHub!"
else
    echo "There was an error pushing the changes to GitHub."
fi
