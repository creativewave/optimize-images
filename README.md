# optimize-images
Description: compress jpg files that was modified less than 1400 minutes ago by using ImageMagick (mogrify).
Usage:
```sh
/home/user/optimize-images.sh /home/user/images/
```
Or create a cron job to run it daily:
```sh
crontab -e
@daily /home/user/optimize-images.sh /home/user/images/
```
