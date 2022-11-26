function disk-usage
  set -l download_dirs ~/downloads/deluge ~/downloads/rtorrent/*
  set -l upload_dirs ~/downloads/drive/*
  for step in download upload
    set -l count_sum 0
    set -l dirs "$step"_dirs
    echo
    echo $step | string upper | bold
    du -shc $$dirs | while read -l size dir
      set -l count
      if test "$dir" = total
        set count $count_sum
      else
        set count (countof $dir)
        set count_sum (math $count_sum + $count)
      end
      echo -n (echo -n "$dir" | string replace -r '/([^/]+)$' /(bold '$1') | string replace -r '(.*/)' (dim '$1')  | _disk-usage-pad -w40 -r -c.)
      echo -n (echo -n "$count" | yellow | _disk-usage-pad -w8 -c.)
      echo -n (echo -n "$size" | yellow | _disk-usage-pad -w10 -c.)
      echo
    end
  end
  echo
end

function _disk-usage-pad
  argparse -i r/right c/char= w/width= -- $argv
  test -n "$_flag_char" || set _flag_char ' '
  set -l text
  if not isatty stdin
    read -z text
  else
    set text $argv
  end
  echo -n $text | ansi-length | read -l len
  set -l pad (dim)(string repeat -n (math $_flag_width - $len) "$_flag_char")(no-dim)
  if set -q _flag_right
    echo "$text$pad"
  else
    echo "$pad$text"
  end
end
