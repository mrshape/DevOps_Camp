 #!/bin/bash
clear
#rm -v prog1.sh
ls -la
error=$?
if [ 1 ]
    then echo error=$error
    else echo zero
fi
