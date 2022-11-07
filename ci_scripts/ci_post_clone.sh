#!/bin/sh

#  ci_post_clone.sh
#  Prenom Africains
#
#  Created by Otourou Da Costa on 07/11/2022.
#  
echo $FIREBASE_SECRET | base64 --decode > $CI_PROJECT_FILE_PATH/Prenom\ Africains/GoogleService-Info.plist
