#!/bin/bash

# PR에서 생성된 md 파일 목록이 files.txt에 있다고 가정
while read file; do
  # md 파일만 처리
  if [[ "$file" == *.md ]]; then
    # 첫 번째 # 헤더 추출 (파일 인코딩 UTF-8 가정)
    title=$(grep -m 1 '^# ' "$file" | sed 's/^# //')
    # 타이틀이 없으면 파일명 사용
    [ -z "$title" ] && title=$(basename "$file")
    # 링크 생성
    link="./$file"
    # 파일이 속한 디렉토리명 추출
    dir=$(dirname "$file")
    dirname_only=$(basename "$dir")
    # hosting 브랜치의 디렉토리와 같은 이름의 디렉토리 내 README 파일 경로
    readme="readme_${dirname_only}.md"
    # README 없으면 생성
    [ -f "$readme" ] || touch "$readme"
    # 이미 해당 타이틀이 기록되어 있지 않으면 추가
    grep -q "$title" "$readme" || echo "- [$title]($link)" >> "$readme"
  fi
done < files.txt
