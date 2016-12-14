decl -hidden str hacker_data

def hacker_stories %{ %sh{
    tmpdir=$(mktemp -d -t kak-temp-XXXXXXXX)
    output=$tmpdir/fifo
    mkfifo ${output}
    data=$tmpdir/data

    (
        fpurl="https://hacker-news.firebaseio.com/v0/topstories.json"
        frontpage=$(curl -s $fpurl | jq '.[]' | head -n50)

        detailsurl="https://hacker-news.firebaseio.com/v0/item/"

        (
        for story in $frontpage; do
            curl -s "$detailsurl/$story.json"  > $tmpdir/$story
            title=$(cat $story | jq -r '.title')
            url=$(cat $story | jq -r '.url')
            echo $title
            echo $story,$url >> $data
        done
        ) > $output

    ) > /dev/null 2> /dev/null &

    echo "edit! -fifo ${output} -scroll *hacker-news*"
    echo "set buffer hacker_data $data"
    echo "hook buffer BufClose .* %{nop %sh{ rm -rf ${tmpdir} } }"
}}

# TODO consider only defining these after hacker_stories is executed
def hacker_open %{nop %sh{
    url=$(sed "${kak_cursor_line}q;d" ${kak_opt_hacker_data} | cut -f2 -d,)
    xdg-open "$url" &
}}

def hacker_comments %{nop %sh{
    baseurl="https://news.ycombinator.com/item?id="
    id=$(sed "${kak_cursor_line}q;d" ${kak_opt_hacker_data} | cut -f1 -d,)
    url="$baseurl$id"
    xdg-open "$url" &
}}
