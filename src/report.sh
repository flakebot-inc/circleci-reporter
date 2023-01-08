#!/bin/sh

REPORT_PATH="${INPUT_PATH}"
if [ ! -e "$REPORT_PATH" ]
then
    echo "The given report path does not exist: ${REPORT_PATH}"
    echo "To resolve this issue, set the flakebot/report 'path' parameter to the directory or file that contains your test artifact(s)."
    exit 1
fi


OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
if [ "$ARCH" = "aarch64" ]; then
	ARCH="arm64"
elif [ "$ARCH" = "x86_64" ]; then
	ARCH="amd64"
fi

getcli() {
	fetch() {
		(set -x; curl -fsSL --retry 3 --retry-connrefused --connect-timeout 5 $1)
	}

	fetch https://get.flakebot.com/r/latest/$OS-$ARCH || \
		fetch https://github.com/flakebot-inc/reporter/releases/latest/download/reporter-$OS-$ARCH
}

echo "📥 Downloading Flakebot Reporter..."

if getcli > ./reporter; then
	: # Successfully fetched binary. Great!
else
	cat <<-eos
		❌ Unable to upload artifacts to Flakebot. See details below.

		Downloading the Flakebot reporter failed with status $?.

		We never want Flakebot to make your builds unstable. Since we're having
		trouble downloading the Flakebot Reporter, we're skipping the
		Flakebot analysis for this build.

		If you continue seeing this problem, please get in touch at
		https://flakebot.com/contact so we can look into this issue.
	eos

	exit 0
fi

chmod +x ./reporter

echo "📬 Reporting artifacts to Flakebot..."

FLAKEBOT_REPORTER_KEY="${!INPUT_FLAKEBOT_REPORTER_KEY}" \
	./reporter "${REPORT_PATH}"

echo "🎉 Flakebot artifacts reported!"
