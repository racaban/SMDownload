#!/bin/bash
rm 200*
#rm -rf image
#mkdir image
page="http://www.schlockmercenary.com/2007-06-30"
echo '<html><body>' > view.html
echo "A"
while [ -n "$page" ]; do
  for idx in {1..100}; do
    #sleep 1
    echo Getting $page
#    rm log
#    wget -o log $page
#    file=`awk '/Saving to/{print $3}' log | grep -o '[-0-9.]*'`
    file=/tmp/schlock
    curl $page > $file

    echo "File " $file
    hxselect '#comic' <$file >> view.html
    page=`cat $file | grep nav-next | sed "s/'/\"/g" | grep 'href=\"[^\"]*\"' | awk -F\" '{print "http://www.schlockmercenary.com" $2}'`
  done
  for img in `grep -o 'http://static.schlockmercenary.com/comics[^"]*' view.html`; do
    #sleep 1
    echo $img;
    wget $img -P image &
  done
  for img in `ls image | grep '?'`; do
    img="image/$img"
    echo $img
    newName=`echo $img | sed 's/\?[0-9]*//'`
    mv $img $newName
  done
  sed -i 's/http:\/\/static.schlockmercenary.com\/comics\//.\/image\//g' view.html
  sed -i 's/?[0-9]*//g' view.html
done

echo '</body></html>' >> view.html
