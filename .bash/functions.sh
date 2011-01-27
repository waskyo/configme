# collection of useful functions
do_track() { 
	for i in *mp3; 
	do 
		track=`mp3info "$i" | grep Track | sed -e 's/.*Track: //'`; 
		track=`printf "%02d" $track`; 
		mv -i "$i" "$track $i"; 
	done; 
}

do_name() { 
	for i in *mp3; 
	do 
		mv "$i" "`echo $i | sed -e 's/ / - /'`" -i; 
	done; 
	for i in *mp3; 
	do 
		mv -i "$i" "$1 - $i"; 
	done; 
}

#do_id3() { 
#	for i in *mp3; 
#	do 
#		eyeD3 -a "$1" -A "$2" "$i"; 
#	done; 
#	for i in *mp3; 
#	do 
#		track=`echo $i | sed -e 's/\.mp3//' | sed -e 's/.*- \([0-9][0-9]\).*/\1/'`; 
#		name=`echo $i | sed -e 's/\.mp3//' | sed -e 's/.*[0-9] - //'`; 
#		eyeD3 -t "$name" -n $track "$i"; 
#	done; 
#	eyeD3 --to-v1.1 *mp3; 
#}

do_id3() { 
	for i in *mp3; 
	do 
		id3v2 -a "$1" -A "$2" "$i"; 
	done; 
	for i in *mp3; 
	do 
		track=`echo $i | sed -e 's/\.mp3//' | sed -e 's/.*- \([0-9][0-9]\).*/\1/'`;  
		name=`echo $i | sed -e 's/\.mp3//' | sed -e 's/.*[0-9] - //'`; 
		id3v2 -t "$name" -T $track "$i"; 
	done; 
	eyeD3 --to-v1.1 *mp3; 
}

fix_display() {
	export DISPLAY=localhost:$1.0
}

tla_diffstat() {
        echo "diffstat:" >> `tla make-log`
        tla changes --diffs | sed -e 's@+++ .*new-files-archive/\./@+++ @' | diffstat >> `tla make-log`
}

get_rapid() {
	list_urls.sed $1 | grep rapidshare > `echo $1 | sed -e 's/\([a-z]\).*/\1/'`
}

montalo() {
	pushd ~/tmp/
	losetup /dev/loop1 prueba_random
	sudo cryptsetup -T 3 create uaich -c aes-cbc-plain /dev/loop1
	mount uaich
	sudo chown ricardo:ricardo uaich
	popd
}

desmontalo() {
	pushd ~/tmp/
	umount uaich
	sudo cryptsetup remove uaich
	losetup -d /dev/loop1
	popd
}

privado() {
	case "X$1" in
		Xup)
			pushd ~
			losetup /dev/loop0 privado/privado.txt
			sudo cryptsetup create privado -c aes-cbc-plain /dev/loop0
			mount privado
			sudo chown ricardo:ricardo privado
			popd
			;;
		Xdown)
			pushd ~/
#			if [ "$x" = "y" ]; then
#				pushd privado/backup
#				bash update.sh
#				popd
#			fi
			umount privado
			sudo cryptsetup remove privado
			losetup -d /dev/loop0
			echo -n "do backup? (y/n) "
			read x
			if [ "$x" = "y" ]; then
				tar Scvzf privado/privado.tar.gz privado/privado.txt
				#rsync privado/privado.tar.gz takamine:~/html/lomio/
				sudo rsync privado/privado.tar.gz /mnt/pr0n/bakop
			fi
			popd
			;;
		*) 
			echo "up or down?"
	esac
}

# fancy xterm window title handling
# see http://glyf.livejournal.com/63106.html
do_xterm() {
	source ~/.bash/preexec.sh

	set_xterm_title() {
		local title="$1"
		#echo -ne "\e]0;$title\007"
		echo -ne "\033]0;$title\007"
	}

	precmd () {
		set_xterm_title "${USER}@${HOSTNAME}: ${PWD/$HOME/~}"
	}

	preexec () {
		set_xterm_title "$1: `dirs -0` @ ${HOSTNAME}"
	}

	preexec_install
}


