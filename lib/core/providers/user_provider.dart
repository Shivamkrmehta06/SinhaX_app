import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrokerInfo {
  final String name;
  final String api;
  final String category;
  final Color avatarColor;
  final bool connected;

  const BrokerInfo({
    required this.name,
    required this.api,
    required this.category,
    required this.avatarColor,
    this.connected = false,
  });

  BrokerInfo copyWith({
    String? name,
    String? api,
    String? category,
    Color? avatarColor,
    bool? connected,
  }) {
    return BrokerInfo(
      name: name ?? this.name,
      api: api ?? this.api,
      category: category ?? this.category,
      avatarColor: avatarColor ?? this.avatarColor,
      connected: connected ?? this.connected,
    );
  }
}

class PlanInfo {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final bool isCurrent;

  const PlanInfo({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
    this.isCurrent = false,
  });
}

class UserInfo {
  final String name;
  final String email;
  final String phone;
  final String pan;
  final String planType;

  const UserInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.pan,
    required this.planType,
  });
}

class UserState {
  final UserInfo user;
  final List<BrokerInfo> brokers;
  final List<PlanInfo> plans;

  const UserState({
    required this.user,
    required this.brokers,
    required this.plans,
  });

  UserState copyWith({
    UserInfo? user,
    List<BrokerInfo>? brokers,
    List<PlanInfo>? plans,
  }) {
    return UserState(
      user: user ?? this.user,
      brokers: brokers ?? this.brokers,
      plans: plans ?? this.plans,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return const UserState(
      user: UserInfo(
        name: 'Shivam Mehta',
        email: 'shivam@example.com',
        phone: '+91 98765 43210',
        pan: 'ABCPM1234F',
        planType: 'Pro',
      ),
      brokers: [
        BrokerInfo(name: 'Zerodha', api: 'Kite Connect', category: 'Indian', avatarColor: Color(0xFF387ED1), connected: true),
        BrokerInfo(name: 'Angel One', api: 'Smart API', category: 'Indian', avatarColor: Color(0xFFE05252)),
        BrokerInfo(name: 'Fyers', api: 'Fyers API', category: 'Indian', avatarColor: Color(0xFF9B59B6)),
        BrokerInfo(name: 'Upstox', api: 'Upstox API', category: 'Indian', avatarColor: Color(0xFFF39C12)),
        BrokerInfo(name: 'Binance', api: 'Binance API', category: 'Crypto', avatarColor: Color(0xFFF0B90B)),
        BrokerInfo(name: 'CoinDCX', api: 'CoinDCX API', category: 'Crypto', avatarColor: Color(0xFF1A73E8)),
        BrokerInfo(name: 'Interactive Brokers', api: 'IB API', category: 'Forex', avatarColor: Color(0xFF2ECC71)),
      ],
      plans: [
        PlanInfo(name: 'Free', price: '₹0', period: '/month', features: ['1 active strategy', '5 paper trades/day', 'Basic screener', 'Email support']),
        PlanInfo(name: 'Pro', price: '₹2,499', period: '/month', features: ['10 active strategies', 'Unlimited live trades', 'Real-time signals', 'Priority support', 'Advanced backtesting', 'Broker integration'], isPopular: true, isCurrent: true),
        PlanInfo(name: 'Elite', price: '₹4,999', period: '/month', features: ['Unlimited strategies', 'AI arbitrage engine', 'Custom algorithms', 'Dedicated manager', 'White-label option']),
      ],
    );
  }

  void toggleBrokerConnection(int index) {
    final b = state.brokers[index];
    final newBrokers = List<BrokerInfo>.from(state.brokers);
    newBrokers[index] = b.copyWith(connected: !b.connected);
    state = state.copyWith(brokers: newBrokers);
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});
