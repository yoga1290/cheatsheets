```bash
#TODO set JAVA_HOME

PWD="$(pwd)" #TODO
GRADLE_PATH="/opt/gradle/gradle-4.10.3/bin/"
export ANDROID_HOME="$PWD/android-sdk"
export ANDROID_SDK_ROOT="$PWD/android-sdk/"
export PATH=$PATH:$GRADLE_PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$JAVA_HOME/bin


# Install Gradle
# https://gradle.org/install/
curl -L \
  -o gradle-4.10.3-bin.zip \
  https://downloads.gradle.org/distributions/gradle-4.10.3-bin.zip
mkdir /opt/gradle
unzip -d /opt/gradle gradle-4.10.3-bin.zip #sudo for local run
cp gradle-4.10.3-bin.zip /opt


# Install SDK tools
# https://developer.android.com/studio/#command-tools
curl -L \
  -o sdk-tools-linux-4333796.zip \
  https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
unzip \
  -d $ANDROID_HOME \
  sdk-tools-linux-4333796.zip;

# Install build-tools & platform:
# https://developer.android.com/studio/command-line/sdkmanager
echo "yes" | $ANDROID_HOME/tools/bin/sdkmanager \
  --install "build-tools;19.1.0" \
  --sdk_root=$ANDROID_SDK_ROOT
echo "yes" | $ANDROID_HOME/tools/bin/sdkmanager \
  --install "platforms;android-19" \
  --sdk_root=$ANDROID_SDK_ROOT
```
