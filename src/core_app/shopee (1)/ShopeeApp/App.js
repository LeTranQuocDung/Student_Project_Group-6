import React, { useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { View, StyleSheet } from 'react-native';

import HomeScreen from './screens/HomeScreen';
import LoginScreen from './screens/LoginScreen';
import AccountScreen from './screens/AccountScreen';
import QRScanScreen from './screens/QRScanScreen';

const Tab = createBottomTabNavigator();
const Stack = createNativeStackNavigator();

function EmptyScreen() {
  return <View style={{ flex: 1, backgroundColor: '#f5f5f5' }} />;
}

function MainTabs({ user, onLogout }) {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarActiveTintColor: '#ee4d2d',
        tabBarInactiveTintColor: '#757575',
        tabBarStyle: {
          height: 58,
          paddingBottom: 6,
          paddingTop: 4,
          borderTopColor: '#efefef',
        },
        tabBarLabelStyle: { fontSize: 10 },
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;
          if (route.name === 'Home') iconName = focused ? 'home' : 'home-outline';
          else if (route.name === 'Explore') iconName = focused ? 'grid' : 'grid-outline';
          else if (route.name === 'QRScan') iconName = 'qr-code';
          else if (route.name === 'Notify') iconName = focused ? 'notifications' : 'notifications-outline';
          else if (route.name === 'Account') iconName = focused ? 'person' : 'person-outline';
          return <Ionicons name={iconName} size={route.name === 'QRScan' ? 28 : 22} color={color} />;
        },
      })}
    >
      <Tab.Screen name="Home" options={{ tabBarLabel: 'Home' }}>
        {props => <HomeScreen {...props} />}
      </Tab.Screen>
      <Tab.Screen name="Explore" component={EmptyScreen} options={{ tabBarLabel: 'Khám Phá' }} />
      <Tab.Screen name="QRScan" options={{
        tabBarLabel: 'Quét QR',
        tabBarIconStyle: {
          backgroundColor: '#ee4d2d',
          width: 44, height: 44,
          borderRadius: 22,
          marginTop: -14,
          justifyContent: 'center',
          alignItems: 'center',
        },
        tabBarActiveTintColor: '#fff',
        tabBarInactiveTintColor: '#fff',
      }}>
        {props => <QRScanScreen {...props} user={user} />}
      </Tab.Screen>
      <Tab.Screen name="Notify" component={EmptyScreen} options={{ tabBarLabel: 'Thông Báo' }} />
      <Tab.Screen name="Account" options={{ tabBarLabel: 'Tôi' }}>
        {props => <AccountScreen {...props} user={user} onLogout={onLogout} />}
      </Tab.Screen>
    </Tab.Navigator>
  );
}

export default function App() {
  const [user, setUser] = useState(null);

  if (!user) {
    return (
      <LoginScreen onLogin={(u) => setUser(u)} />
    );
  }

  return (
    <NavigationContainer>
      <MainTabs user={user} onLogout={() => setUser(null)} />
    </NavigationContainer>
  );
}
