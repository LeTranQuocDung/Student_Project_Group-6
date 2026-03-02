import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, StatusBar, Alert, Vibration } from 'react-native';
import { CameraView, useCameraPermissions } from 'expo-camera';
import { Ionicons } from '@expo/vector-icons';
import { API_BASE } from '../config';

export default function QRScanScreen({ navigation, user }) {
  const [permission, requestPermission] = useCameraPermissions();
  const [scanned, setScanned] = useState(false);
  const [resultMsg, setResultMsg] = useState('');
  const [resultType, setResultType] = useState(''); // 'success' | 'error'

  if (!permission) {
    return <View style={styles.container} />;
  }

  if (!permission.granted) {
    return (
      <View style={styles.permissionContainer}>
        <StatusBar backgroundColor="#000" barStyle="light-content" />
        <Ionicons name="camera" size={48} color="#fff" />
        <Text style={styles.permissionText}>Cần quyền truy cập Camera để quét mã QR</Text>
        <TouchableOpacity style={styles.permissionBtn} onPress={requestPermission}>
          <Text style={styles.permissionBtnText}>Cấp quyền Camera</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const handleBarCodeScanned = async ({ data }) => {
    if (scanned) return;
    setScanned(true);
    Vibration.vibrate(200);

    console.log('[QR Scan] Decoded:', data);

    // Extract token from QR data
    let token = data;
    try {
      const url = new URL(data);
      token = url.searchParams.get('token') || data;
    } catch (e) {
      token = data;
    }

    setResultMsg('Đang xác nhận...');
    setResultType('');

    try {
      const res = await fetch(`${API_BASE}/qr-login?action=confirm&token=${encodeURIComponent(token)}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'ngrok-skip-browser-warning': 'true',
        },
      });
      const json = await res.json();

      if (json.success || json.status === 'OK' || json.status === 'CONFIRMED') {
        setResultMsg('✅ Đăng nhập thành công!\nMáy tính đã được đăng nhập.');
        setResultType('success');
        Vibration.vibrate([0, 100, 100, 100]);
      } else {
        setResultMsg('❌ Mã QR không hợp lệ hoặc đã hết hạn');
        setResultType('error');
        setTimeout(() => setScanned(false), 3000);
      }
    } catch (e) {
      console.log('QR confirm error:', e);
      setResultMsg('❌ Không kết nối được server.\nKiểm tra IP trong config.js');
      setResultType('error');
      setTimeout(() => setScanned(false), 3000);
    }
  };

  return (
    <View style={styles.container}>
      <StatusBar backgroundColor="#000" barStyle="light-content" />

      {/* HEADER */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={24} color="#fff" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Quét mã QR</Text>
        <View style={{ width: 24 }} />
      </View>

      {/* CAMERA */}
      <View style={styles.cameraContainer}>
        <CameraView
          style={styles.camera}
          barcodeScannerSettings={{ barcodeTypes: ['qr'] }}
          onBarcodeScanned={scanned ? undefined : handleBarCodeScanned}
        >
          {/* Scan frame overlay */}
          <View style={styles.overlay}>
            <View style={styles.overlayTop} />
            <View style={styles.overlayMiddle}>
              <View style={styles.overlaySide} />
              <View style={styles.scanFrame}>
                {/* Corner decorations */}
                <View style={[styles.corner, styles.cornerTL]} />
                <View style={[styles.corner, styles.cornerTR]} />
                <View style={[styles.corner, styles.cornerBL]} />
                <View style={[styles.corner, styles.cornerBR]} />
                {/* Scan line animation */}
                {!scanned && <View style={styles.scanLine} />}
              </View>
              <View style={styles.overlaySide} />
            </View>
            <View style={styles.overlayBottom}>
              <Text style={styles.hint}>Đưa mã QR vào khung hình để quét</Text>
              <Text style={styles.hintSub}>Dùng để đăng nhập Shopee trên máy tính</Text>
            </View>
          </View>
        </CameraView>
      </View>

      {/* RESULT */}
      {resultMsg !== '' && (
        <View style={[
          styles.result,
          resultType === 'success' && styles.resultSuccess,
          resultType === 'error' && styles.resultError,
        ]}>
          <Text style={styles.resultText}>{resultMsg}</Text>
          {resultType === 'success' && (
            <TouchableOpacity
              style={styles.doneBtn}
              onPress={() => navigation.goBack()}
            >
              <Text style={styles.doneBtnText}>Hoàn tất</Text>
            </TouchableOpacity>
          )}
        </View>
      )}

      {/* Retry button */}
      {scanned && resultType === 'error' && (
        <TouchableOpacity style={styles.retryBtn} onPress={() => setScanned(false)}>
          <Text style={styles.retryText}>Quét lại</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

const SCAN_SIZE = 250;

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#000' },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: 44,
    paddingBottom: 12,
    paddingHorizontal: 16,
    backgroundColor: 'rgba(0,0,0,0.5)',
    position: 'absolute',
    top: 0, left: 0, right: 0,
    zIndex: 10,
  },
  headerTitle: { color: '#fff', fontSize: 17, fontWeight: '600' },
  // Permission
  permissionContainer: {
    flex: 1,
    backgroundColor: '#000',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 40,
    gap: 16,
  },
  permissionText: { color: '#fff', fontSize: 15, textAlign: 'center', lineHeight: 22 },
  permissionBtn: {
    backgroundColor: '#ee4d2d',
    paddingHorizontal: 28,
    paddingVertical: 12,
    borderRadius: 8,
    marginTop: 8,
  },
  permissionBtnText: { color: '#fff', fontSize: 15, fontWeight: '600' },
  // Camera
  cameraContainer: { flex: 1 },
  camera: { flex: 1 },
  // Overlay
  overlay: { flex: 1 },
  overlayTop: { flex: 1, backgroundColor: 'rgba(0,0,0,0.6)' },
  overlayMiddle: { flexDirection: 'row' },
  overlaySide: { flex: 1, backgroundColor: 'rgba(0,0,0,0.6)' },
  overlayBottom: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.6)',
    alignItems: 'center',
    paddingTop: 24,
  },
  scanFrame: {
    width: SCAN_SIZE,
    height: SCAN_SIZE,
  },
  corner: {
    position: 'absolute',
    width: 24, height: 24,
    borderColor: '#ee4d2d',
  },
  cornerTL: { top: 0, left: 0, borderTopWidth: 3, borderLeftWidth: 3 },
  cornerTR: { top: 0, right: 0, borderTopWidth: 3, borderRightWidth: 3 },
  cornerBL: { bottom: 0, left: 0, borderBottomWidth: 3, borderLeftWidth: 3 },
  cornerBR: { bottom: 0, right: 0, borderBottomWidth: 3, borderRightWidth: 3 },
  scanLine: {
    position: 'absolute',
    left: 4, right: 4,
    height: 2,
    backgroundColor: '#ee4d2d',
    top: '50%',
  },
  hint: { color: 'rgba(255,255,255,0.8)', fontSize: 14, marginTop: 8 },
  hintSub: { color: 'rgba(255,255,255,0.5)', fontSize: 12, marginTop: 4 },
  // Result
  result: {
    position: 'absolute',
    bottom: 100,
    left: 20, right: 20,
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
  },
  resultSuccess: { backgroundColor: 'rgba(76,175,80,0.9)' },
  resultError: { backgroundColor: 'rgba(244,67,54,0.9)' },
  resultText: { color: '#fff', fontSize: 15, textAlign: 'center', lineHeight: 22 },
  doneBtn: {
    backgroundColor: '#fff',
    paddingHorizontal: 28,
    paddingVertical: 10,
    borderRadius: 8,
    marginTop: 12,
  },
  doneBtnText: { color: '#4caf50', fontWeight: '600', fontSize: 15 },
  retryBtn: {
    position: 'absolute',
    bottom: 50,
    alignSelf: 'center',
    backgroundColor: '#ee4d2d',
    paddingHorizontal: 28,
    paddingVertical: 12,
    borderRadius: 8,
  },
  retryText: { color: '#fff', fontSize: 15, fontWeight: '600' },
});
