import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, StatusBar, Alert } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

export default function AccountScreen({ user, onLogout }) {
  const orderTabs = [
    { icon: 'wallet-outline', label: 'Chờ xác nhận' },
    { icon: 'cube-outline', label: 'Chờ lấy hàng' },
    { icon: 'car-outline', label: 'Đang giao' },
    { icon: 'star-outline', label: 'Đánh giá' },
    { icon: 'arrow-undo-outline', label: 'Trả hàng' },
  ];

  const menuItems = [
    { icon: 'heart-outline', label: 'Đã thích', color: '#ee4d2d' },
    { icon: 'time-outline', label: 'Đã xem gần đây', color: '#ee4d2d' },
    { icon: 'logo-bitcoin', label: 'Shopee Xu', color: '#ffb400' },
    { icon: 'wallet-outline', label: 'Ví ShopeePay', color: '#ee4d2d' },
    { icon: 'star-outline', label: 'Đánh giá của tôi', color: '#ee4d2d' },
    { icon: 'settings-outline', label: 'Thiết lập tài khoản', color: '#ee4d2d' },
    { icon: 'help-circle-outline', label: 'Trung tâm hỗ trợ', color: '#ee4d2d' },
  ];

  return (
    <View style={styles.container}>
      <StatusBar backgroundColor="#ee4d2d" barStyle="light-content" />
      <ScrollView>
        {/* HEADER */}
        <View style={styles.header}>
          <View style={styles.avatar}>
            <Ionicons name="person" size={28} color="#fff" />
          </View>
          <View>
            <Text style={styles.name}>{user?.fullName || 'User'}</Text>
            <Text style={styles.email}>{user?.email || ''}</Text>
          </View>
        </View>

        {/* ĐƠN MUA */}
        <View style={styles.ordersHeader}>
          <Text style={styles.ordersTitle}>Đơn mua</Text>
          <Text style={styles.ordersLink}>Xem lịch sử &gt;</Text>
        </View>
        <View style={styles.orderTabs}>
          {orderTabs.map((tab, i) => (
            <TouchableOpacity key={i} style={styles.orderTab}>
              <Ionicons name={tab.icon} size={24} color="#333" />
              <Text style={styles.orderTabLabel}>{tab.label}</Text>
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.spacer} />

        {/* MENU */}
        {menuItems.map((item, i) => (
          <TouchableOpacity key={i} style={styles.menuItem}>
            <Ionicons name={item.icon} size={22} color={item.color} />
            <Text style={styles.menuLabel}>{item.label}</Text>
            <Ionicons name="chevron-forward" size={16} color="#ccc" />
          </TouchableOpacity>
        ))}

        <View style={styles.spacer} />

        {/* LOGOUT */}
        <TouchableOpacity
          style={styles.logoutBtn}
          onPress={() => {
            Alert.alert('Đăng xuất', 'Bạn có chắc muốn đăng xuất?', [
              { text: 'Hủy', style: 'cancel' },
              { text: 'Đăng xuất', style: 'destructive', onPress: onLogout },
            ]);
          }}
        >
          <Ionicons name="log-out-outline" size={22} color="#ee4d2d" />
          <Text style={styles.logoutText}>Đăng xuất</Text>
        </TouchableOpacity>

        <View style={{ height: 100 }} />
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5f5f5' },
  header: {
    backgroundColor: '#ee4d2d',
    flexDirection: 'row',
    alignItems: 'center',
    paddingTop: 50,
    paddingBottom: 24,
    paddingHorizontal: 20,
    gap: 14,
  },
  avatar: {
    width: 56, height: 56,
    borderRadius: 28,
    backgroundColor: 'rgba(255,255,255,0.25)',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: 'rgba(255,255,255,0.5)',
  },
  name: { color: '#fff', fontSize: 17, fontWeight: '600' },
  email: { color: 'rgba(255,255,255,0.8)', fontSize: 12, marginTop: 2 },
  ordersHeader: {
    backgroundColor: '#fff',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 14,
  },
  ordersTitle: { fontSize: 15, fontWeight: '600' },
  ordersLink: { fontSize: 12, color: '#757575' },
  orderTabs: {
    backgroundColor: '#fff',
    flexDirection: 'row',
    paddingVertical: 12,
    borderTopWidth: 1,
    borderTopColor: '#f0f0f0',
  },
  orderTab: { flex: 1, alignItems: 'center', gap: 6 },
  orderTabLabel: { fontSize: 10, color: '#333', textAlign: 'center' },
  spacer: { height: 8 },
  menuItem: {
    backgroundColor: '#fff',
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 14,
    gap: 14,
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  menuLabel: { flex: 1, fontSize: 14, color: '#222' },
  logoutBtn: {
    backgroundColor: '#fff',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    gap: 8,
  },
  logoutText: { color: '#ee4d2d', fontSize: 15, fontWeight: '600' },
});
