import React, { useState, useEffect } from 'react';
import {
  View, Text, TextInput, ScrollView, Image,
  StyleSheet, TouchableOpacity, FlatList, StatusBar, Dimensions, ActivityIndicator
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { API_BASE } from '../config';
import ProductCard from '../components/ProductCard';

const { width } = Dimensions.get('window');

export default function HomeScreen({ navigation }) {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchText, setSearchText] = useState('');

  useEffect(() => { loadProducts(); }, []);

  const loadProducts = async (txt = '') => {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/api/products?txt=${encodeURIComponent(txt)}`, {
        headers: { 'ngrok-skip-browser-warning': 'true' },
      });
      const data = await res.json();
      setProducts(data);
    } catch (e) {
      console.log('Load products error:', e);
      // Demo data nếu không kết nối được backend
      setProducts([
        { id: 1, name: 'Áo thun nam cao cấp', minPrice: 159000, soldCount: 1200, imageUrl: '' },
        { id: 2, name: 'Tai nghe Bluetooth 5.0', minPrice: 89000, soldCount: 3400, imageUrl: '' },
        { id: 3, name: 'Ốp lưng iPhone 15', minPrice: 29000, soldCount: 5600, imageUrl: '' },
        { id: 4, name: 'Giày thể thao nam', minPrice: 299000, soldCount: 890, imageUrl: '' },
        { id: 5, name: 'Balo laptop 15.6 inch', minPrice: 199000, soldCount: 2100, imageUrl: '' },
        { id: 6, name: 'Đồng hồ thông minh', minPrice: 450000, soldCount: 780, imageUrl: '' },
      ]);
    }
    setLoading(false);
  };

  const doSearch = () => { loadProducts(searchText); };

  const icons = [
    { label: 'Khuyến Mãi', icon: 'pricetag', color: '#ee4d2d' },
    { label: 'Mã Giảm Giá', icon: 'ticket', color: '#26aa99' },
    { label: 'Freeship', icon: 'car', color: '#00bfa5' },
    { label: 'Shopee Xu', icon: 'logo-bitcoin', color: '#ffb400' },
    { label: 'Flash Sale', icon: 'flash', color: '#ee4d2d' },
  ];

  return (
    <View style={styles.container}>
      <StatusBar backgroundColor="#ee4d2d" barStyle="light-content" />

      {/* HEADER */}
      <View style={styles.header}>
        <Text style={styles.logo}>
          <Ionicons name="bag-handle" size={20} /> Shopee
        </Text>
        <View style={styles.searchBar}>
          <Ionicons name="search" size={16} color="#ee4d2d" />
          <TextInput
            style={styles.searchInput}
            placeholder="Tìm kiếm sản phẩm..."
            placeholderTextColor="#999"
            value={searchText}
            onChangeText={setSearchText}
            onSubmitEditing={doSearch}
            returnKeyType="search"
          />
        </View>
        <TouchableOpacity onPress={() => navigation.navigate('Account')}>
          <Ionicons name="cart-outline" size={24} color="#fff" />
        </TouchableOpacity>
      </View>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* BANNER */}
        <View style={styles.banner}>
          <View style={styles.bannerGradient}>
            <Text style={styles.bannerTitle}>SHOPEE SALE 🔥</Text>
            <Text style={styles.bannerSub}>Giảm đến 50% - Freeship mọi đơn</Text>
          </View>
        </View>

        {/* ICON MENU */}
        <View style={styles.iconRow}>
          {icons.map((item, i) => (
            <TouchableOpacity key={i} style={styles.iconItem}>
              <View style={[styles.iconCircle, { backgroundColor: item.color + '15' }]}>
                <Ionicons name={item.icon} size={22} color={item.color} />
              </View>
              <Text style={styles.iconLabel}>{item.label}</Text>
            </TouchableOpacity>
          ))}
        </View>

        {/* FLASH SALE */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={styles.flashTitle}>
              <Ionicons name="flash" size={16} color="#ee4d2d" /> FLASH SALE
            </Text>
            <Text style={styles.seeAll}>Xem tất cả &gt;</Text>
          </View>
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.flashScroll}>
            {products.slice(0, 6).map((p, i) => (
              <TouchableOpacity key={i} style={styles.flashCard}>
                <Image
                  source={{ uri: p.imageUrl?.startsWith('http') ? p.imageUrl : 'https://via.placeholder.com/120' }}
                  style={styles.flashImg}
                />
                <Text style={styles.flashPrice}>₫{Number(p.minPrice || 0).toLocaleString('vi-VN')}</Text>
                <Text style={styles.flashSold}>Đang bán chạy</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* GỢI Ý HÔM NAY */}
        <View style={styles.suggestHeader}>
          <Text style={styles.suggestTitle}>GỢI Ý HÔM NAY</Text>
        </View>

        {loading ? (
          <ActivityIndicator size="large" color="#ee4d2d" style={{ padding: 40 }} />
        ) : (
          <View style={styles.productGrid}>
            {products.map((p, i) => (
              <ProductCard key={i} product={p} onPress={() => {}} />
            ))}
          </View>
        )}

        <View style={{ height: 20 }} />
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
    paddingHorizontal: 12,
    paddingTop: 40,
    paddingBottom: 10,
    gap: 10,
  },
  logo: { color: '#fff', fontSize: 18, fontWeight: '700' },
  searchBar: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    borderRadius: 4,
    paddingHorizontal: 10,
    height: 36,
    gap: 6,
  },
  searchInput: { flex: 1, fontSize: 13, color: '#222', padding: 0 },
  // Banner
  banner: { height: 140, backgroundColor: '#ee4d2d' },
  bannerGradient: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#ee4d2d',
    borderBottomLeftRadius: 12,
    borderBottomRightRadius: 12,
  },
  bannerTitle: { color: '#fff', fontSize: 22, fontWeight: '800' },
  bannerSub: { color: 'rgba(255,255,255,.85)', fontSize: 13, marginTop: 4 },
  // Icons
  iconRow: {
    flexDirection: 'row',
    backgroundColor: '#fff',
    paddingVertical: 14,
    paddingHorizontal: 4,
    justifyContent: 'space-around',
  },
  iconItem: { alignItems: 'center', width: 60 },
  iconCircle: {
    width: 42, height: 42,
    borderRadius: 21,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 6,
  },
  iconLabel: { fontSize: 10, color: '#333', textAlign: 'center' },
  // Flash Sale
  section: { backgroundColor: '#fff', marginTop: 8, padding: 12 },
  sectionHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 10 },
  flashTitle: { fontSize: 16, fontWeight: '700', color: '#ee4d2d' },
  seeAll: { fontSize: 12, color: '#ee4d2d' },
  flashScroll: {},
  flashCard: {
    width: 110,
    marginRight: 8,
    backgroundColor: '#fff',
    borderRadius: 2,
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: '#f0f0f0',
  },
  flashImg: { width: 110, height: 110, backgroundColor: '#f5f5f5', resizeMode: 'cover' },
  flashPrice: { fontSize: 13, color: '#ee4d2d', fontWeight: '600', paddingHorizontal: 6, paddingTop: 6 },
  flashSold: { fontSize: 10, color: '#757575', paddingHorizontal: 6, paddingBottom: 6 },
  // Suggest
  suggestHeader: {
    backgroundColor: '#fff',
    marginTop: 8,
    padding: 12,
    alignItems: 'center',
    borderBottomWidth: 2,
    borderBottomColor: '#ee4d2d',
  },
  suggestTitle: { fontSize: 15, fontWeight: '700', color: '#ee4d2d', textTransform: 'uppercase' },
  productGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    paddingHorizontal: 4,
    paddingTop: 4,
  },
});
