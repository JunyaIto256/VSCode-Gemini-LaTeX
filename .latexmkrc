#!/usr/bin/env perl

# 文書側の指定を優先し、なければ documentclass からエンジンを推定する。
#   % !TEX program = lualatex
#   % !TEX program = uplatex
my $texfile = find_tex_file();
my $engine = detect_engine($texfile);

if ($engine eq 'uplatex' || $engine eq 'platex') {
    # pLaTeX / upLaTeX で DVI を作成し、dvipdfmx で PDF 化する（pdf_mode = 3）
    $pdf_mode = 3;
    $latex = "$engine -synctex=1 -halt-on-error "
           . "-interaction=nonstopmode %O %S";
    $dvipdf = 'dvipdfmx %O -o %D %S';
} else {
    # LuaLaTeX で直接 PDF を生成する（pdf_mode = 4）
    $pdf_mode = 4;
    $lualatex = 'lualatex -synctex=1 -halt-on-error '
              . '-interaction=nonstopmode %O %S';
}

# 参考文献の処理
$bibtex = 'upbibtex %O %B';

# 索引の処理（日本語対応）
$makeindex = 'mendex %O -o %D %S';

# クリーンアップ対象ファイル
$clean_full_ext = '%R.synctex.gz %R.auxlock';

sub find_tex_file {
    for my $arg (@ARGV) {
        next if $arg =~ /^-/;

        return $arg if $arg =~ /\.tex$/i && -f $arg;

        my $candidate = "$arg.tex";
        return $candidate if -f $candidate;
    }

    return undef;
}

sub detect_engine {
    my ($file) = @_;

    return 'lualatex' unless defined $file && -f $file;

    open(my $fh, '<:raw', $file) or return 'lualatex';
    my $content = do { local $/; <$fh> };
    close($fh);

    if ($content =~ /^\s*%\s*!TEX\s+program\s*=\s*(lualatex|uplatex|platex)\s*$/mi) {
        return lc($1);
    }

    if ($content =~ /\\documentclass(?:\[[^\]]*\])?\{(?:jsarticle|jsbook|jsreport|jarticle|jbook|tarticle|tbook)\}/) {
        return 'uplatex';
    }

    return 'lualatex';
}
