#!/bin/bash

# PR에서 추가된 파일 목록 처리
while read file; do
  # md 파일만 처리
  if [[ "$file" == *.md ]]; then
    # 첫 번째 # 헤더 추출
    title=$(grep -m 1 '^# ' "$file" | sed 's/^# //')
    # 타이틀이 없으면 파일명 사용
    echo "Grep result:"
    grep -m 1 '^# ' "$file"
    [ -z "$title" ] && title=$(basename "$file")
    # 파일이 속한 디렉토리명 추출
    dir=$(dirname "$file")
    dirname_only=$(basename "$dir")
    # 해당 디렉토리의 readme 파일 경로 (readme_디렉토리명.md 형식)
    readme=$(find "$dir" -maxdepth 1 -name "readme_*.md" | head -n 1)
    # 일치하는 파일이 없으면 새로 생성
    if [ -z "$readme" ]; then
      readme="$dir/readme_${dirname_only}.md"
      touch "$readme"
    fi
    # 파일명만 추출 (경로 제외)
    filename=$(basename "$file")
    # 상대 경로 링크 생성
    link="./$filename"
    # 이미 해당 타이틀이 기록되어 있지 않으면 추가
    grep -q "$title" "$readme" || echo "- [$title]($link)" >> "$readme"
    echo "Added '$title' to $readme"
  fi
done < /tmp/files.txt
