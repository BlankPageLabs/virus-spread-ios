#!/bin/sh

if [ -z "${PROJECT_DIR}" ]; then
        PROJECT_DIR=`pwd`
fi

if [ -z "${PREFIX}" ]; then
        PREFIX=""
fi

SVN_DIR="${PROJECT_DIR}/.svn"
GIT_DIR="${PROJECT_DIR}/.git"

if [ -d "${GIT_DIR}" ]; then
		GIT_TAG=`xcrun git describe --abbrev=0`
		GIT_COMMIT_COUNT=`xcrun git rev-list ${GIT_TAG}..HEAD | wc -l | tr -d ' '`
        GIT_TOTAL_COMMIT_COUNT=`xcrun git rev-list HEAD | wc -l | tr -d ' '`
        RELEASE_VERSION=`xcrun git describe`
        BUNDLE_VERSION_SHORT="${GIT_TAG}"
        BUNDLE_VERSION="${GIT_TOTAL_COMMIT_COUNT}"
elif [ -d "${SVN_DIR}" ]; then
        BUNDLE_VERSION_SHORT=`xcrun svnversion -nc "${PROJECT_DIR}" | sed -e 's/^[^:]*://;s/[A-Za-z]//' | tr -d ' '`
        BUNDLE_VERSION="${BUILD_NUMBER}"
else 
        BUNDLE_VERSION="0"
        BUNDLE_VERSION_SHORT="1"
fi

if [ -z "$1" ]; then
	echo "${BUNDLE_VERSION_SHORT}"
else
        echo "#define ${PREFIX}BUNDLE_VERSION ${BUNDLE_VERSION}" > $1
        echo "#define ${PREFIX}BUNDLE_VERSION_SHORT ${BUNDLE_VERSION_SHORT}" >> $1
        echo "#define ${PREFIX}VERSION_STRING @\"${BUNDLE_VERSION_SHORT}.${GIT_COMMIT_COUNT}\"" >> $1
        echo "#define ${PREFIX}RELEASE_STRING @\"${RELEASE_VERSION}\"" >> $1

        find "${PROJECT_DIR}" -iname "*.plist" -maxdepth 2 -exec touch {} \;
fi
