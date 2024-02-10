#!/bin/sh

case "$(pidof dropbear | wc -w)" in
# Add the desired dropbear options here
0) dropbear &
   ;;
esac

exit 0
