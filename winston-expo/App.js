// Winston for Expo Go: a native shell around the hosted Winston web app.
// Scan the QR code from `npx expo start` with Expo Go (iOS or Android).
import React, { useCallback, useEffect, useRef, useState } from 'react';
import { ActivityIndicator, BackHandler, Linking, Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';
import { WebView } from 'react-native-webview';
import { requestRecordingPermissionsAsync } from 'expo-audio';

// Always loads the latest Winston, so app updates need no new build.
const SITE = 'https://miyagagne.github.io/Miya-s-Sandbox/winston/';
const URL = `${SITE}?app=expo`;
const SKY = '#68cdfd';

// Tells the web app it is running inside the native app (hides the "Install" card, etc.).
const BEFORE_LOAD = `window.__NATIVE_APP='expo';true;`;

export default function App() {
  const web = useRef(null);
  const [canBack, setCanBack] = useState(false);
  const [failed, setFailed] = useState(false);
  const [loading, setLoading] = useState(true);
  const [key, setKey] = useState(0);

  // Ask for the microphone up front so live class notes work inside the WebView.
  useEffect(() => {
    requestRecordingPermissionsAsync().catch(() => {});
  }, []);

  // Android hardware back button goes back inside Winston first.
  useEffect(() => {
    if (Platform.OS !== 'android') return undefined;
    const sub = BackHandler.addEventListener('hardwareBackPress', () => {
      if (canBack && web.current) { web.current.goBack(); return true; }
      return false;
    });
    return () => sub.remove();
  }, [canBack]);

  // Keep Winston's own pages inside the app; open Google Docs, Calendar and other sites in the browser.
  const onShouldStart = useCallback((req) => {
    const u = req.url || '';
    if (u.startsWith(SITE) || u.startsWith('about:') || u.startsWith('blob:') || u.startsWith('data:')) return true;
    if (/^https?:/.test(u)) { Linking.openURL(u).catch(() => {}); return false; }
    return true;
  }, []);

  const retry = () => { setFailed(false); setLoading(true); setKey((k) => k + 1); };

  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.root} edges={['top', 'left', 'right', 'bottom']}>
        <StatusBar style="dark" backgroundColor={SKY} />
        {failed ? (
          <View style={styles.center}>
            <Text style={styles.emoji}>🐶</Text>
            <Text style={styles.title}>Winston Can't Reach The Internet</Text>
            <Text style={styles.sub}>Check your connection and try again.</Text>
            <Pressable style={styles.btn} onPress={retry}><Text style={styles.btnText}>Try Again</Text></Pressable>
          </View>
        ) : (
          <WebView
            key={key}
            ref={web}
            source={{ uri: URL }}
            style={styles.web}
            injectedJavaScriptBeforeContentLoaded={BEFORE_LOAD}
            javaScriptEnabled
            domStorageEnabled
            sharedCookiesEnabled
            allowsInlineMediaPlayback
            mediaPlaybackRequiresUserAction={false}
            mediaCapturePermissionGrantType="grant"
            allowsBackForwardNavigationGestures
            setSupportMultipleWindows={false}
            pullToRefreshEnabled
            overScrollMode="never"
            bounces={false}
            onShouldStartLoadWithRequest={onShouldStart}
            onNavigationStateChange={(s) => setCanBack(!!s.canGoBack)}
            onLoadEnd={() => setLoading(false)}
            onError={() => setFailed(true)}
            onHttpError={(e) => { if (e.nativeEvent.statusCode >= 500) setFailed(true); }}
          />
        )}
        {loading && !failed ? (
          <View style={styles.loader} pointerEvents="none">
            <Text style={styles.emoji}>🐾</Text>
            <ActivityIndicator color="#ff9a3d" />
          </View>
        ) : null}
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: SKY },
  web: { flex: 1, backgroundColor: SKY },
  loader: { ...StyleSheet.absoluteFillObject, backgroundColor: SKY, alignItems: 'center', justifyContent: 'center', gap: 12 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 28, gap: 10 },
  emoji: { fontSize: 56 },
  title: { fontSize: 20, fontWeight: '700', color: '#43392f', textAlign: 'center' },
  sub: { fontSize: 15, color: '#5b6b78', textAlign: 'center' },
  btn: { marginTop: 10, backgroundColor: '#3ccf5f', paddingVertical: 12, paddingHorizontal: 26, borderRadius: 14 },
  btnText: { color: '#fff', fontSize: 16, fontWeight: '700' },
});
