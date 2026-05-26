#!/usr/bin/env perl

# LuaLaTeX で直接 PDF を生成する（pdf_mode = 4）
$pdf_mode = 4;

# LuaLaTeX のオプション
$lualatex = 'lualatex -synctex=1 -halt-on-error '
           . '-interaction=nonstopmode %O %S';

# 参考文献の処理
$bibtex = 'upbibtex %O %B';

# 索引の処理（日本語対応）
$makeindex = 'mendex %O -o %D %S';

# クリーンアップ対象ファイル
$clean_full_ext = '%R.synctex.gz %R.auxlock';
