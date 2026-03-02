import React from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity, Dimensions } from 'react-native';

const { width } = Dimensions.get('window');
const CARD_WIDTH = (width - 12) / 2;

export default function ProductCard({ product, onPress }) {
  const imgSrc = product.imageUrl?.startsWith('http')
    ? product.imageUrl
    : `https://via.placeholder.com/200x200.png?text=SP`;

  return (
    <TouchableOpacity style={styles.card} onPress={onPress} activeOpacity={0.85}>
      <Image source={{ uri: imgSrc }} style={styles.image} />
      <View style={styles.info}>
        <Text style={styles.name} numberOfLines={2}>{product.name || 'Sản phẩm'}</Text>
        <View style={styles.priceRow}>
          <Text style={styles.price}>
            ₫{Number(product.minPrice || 0).toLocaleString('vi-VN')}
          </Text>
        </View>
        <Text style={styles.sold}>Đã bán {product.soldCount || 0}</Text>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    width: CARD_WIDTH,
    backgroundColor: '#fff',
    marginBottom: 4,
    borderRadius: 2,
    overflow: 'hidden',
  },
  image: {
    width: '100%',
    height: CARD_WIDTH,
    backgroundColor: '#f5f5f5',
    resizeMode: 'cover',
  },
  info: {
    padding: 8,
  },
  name: {
    fontSize: 12,
    lineHeight: 17,
    color: '#222',
    marginBottom: 4,
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  price: {
    fontSize: 14,
    fontWeight: '600',
    color: '#ee4d2d',
  },
  sold: {
    fontSize: 11,
    color: '#757575',
    marginTop: 2,
  },
});
