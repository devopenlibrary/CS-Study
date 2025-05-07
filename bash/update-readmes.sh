#!/bin/bash

# PR에서 추가된 파일 목록 처리
while read file; do
  # md 파일만 처리
  if [[ "$file" == *.md ]]; then
    # 첫 번째 # 헤더 추출
    title=$(grep -m 1 '^# ' "$file" | sed 's/^# //')
    # 타이틀이 없으면 파일명 사용
    [ -z "$title" ] && title=$(basename "$file")
    # 파일이 속한 디렉토리명 추출
    dir=$(dirname "$file")
    dirname_only=$(basename "$dir")
    # 해당 디렉토리의 readme 파일 경로 (readme_디렉토리명.md 형식)
    readme="$dir/readme_${dirname_only}.md"
    # 파일명만 추출 (경로 제외)
    filename=$(basename "$file")
    # 상대 경로 링크 생성
    link="./$filename"
    # README 없으면 생성
    [ -f "$readme" ] || touch "$readme"
    # 이미 해당 타이틀이 기록되어 있지 않으면 추가
    grep -q "$title" "$readme" || echo "- [$title]($link)" >> "$readme"
    echo "Added '$title' to $readme"
  fi
done < /tmp/files.txt
