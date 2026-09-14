import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  // ==================== PAYMENT METHODS ====================
  
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    setState(() {
      _paymentMethods = [
        PaymentMethod(
          id: '1',
          type: PaymentType.creditCard,
          name: 'Visa Credit Card',
          lastFour: '4242',
          expiryDate: '12/25',
          isDefault: true,
          icon: Icons.video_stable,
          color: const Color(0xFF1A1F71),
        ),
        PaymentMethod(
          id: '2',
          type: PaymentType.creditCard,
          name: 'Mastercard',
          lastFour: '8888',
          expiryDate: '06/26',
          isDefault: false,
          icon: Icons.manage_history_rounded,
          color: const Color(0xFFEB001B),
        ),
        PaymentMethod(
          id: '3',
          type: PaymentType.mobileMoney,
          name: 'M-Pesa',
          phoneNumber: '0712345678',
          isDefault: false,
          icon: Icons.mobile_friendly_outlined,
          color: const Color(0xFF4CAF50),
        ),
        PaymentMethod(
          id: '4',
          type: PaymentType.mobileMoney,
          name: 'Tigo Pesa',
          phoneNumber: '0712345679',
          isDefault: false,
          icon: Icons.mobile_friendly_outlined,
          color: const Color(0xFFE53935),
        ),
      ];
    });
  }

  void _setDefaultPayment(String id) {
    setState(() {
      for (var method in _paymentMethods) {
        method.isDefault = method.id == id;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default payment method updated'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deletePaymentMethod(String id) {
    setState(() {
      _paymentMethods.removeWhere((method) => method.id == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment method removed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddPaymentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const AddPaymentSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddPaymentDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _paymentMethods.isEmpty
              ? _buildEmptyState()
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Default Payment Section
                    if (_paymentMethods.any((m) => m.isDefault))
                      _buildSectionHeader('Default Payment Method'),
                    
                    ..._paymentMethods.where((m) => m.isDefault).map((method) {
                      return _buildPaymentCard(method);
                    }),
                    
                    const SizedBox(height: 16),
                    
                    // Other Payment Methods
                    if (_paymentMethods.any((m) => !m.isDefault))
                      _buildSectionHeader('Other Payment Methods'),
                    
                    ..._paymentMethods.where((m) => !m.isDefault).map((method) {
                      return _buildPaymentCard(method);
                    }),
                    
                    const SizedBox(height: 24),
                    
                    // Add Payment Button
                    _buildAddPaymentButton(),
                  ],
                ),
    );
  }

  // ==================== EMPTY STATE ====================
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Payment Methods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first payment method',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showAddPaymentDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Add Payment Method'),
          ),
        ],
      ),
    );
  }

  // ==================== SECTION HEADER ====================
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  // ==================== PAYMENT CARD ====================
  
  Widget _buildPaymentCard(PaymentMethod method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: method.isDefault
            ? Border.all(color: const Color(0xFFB71C1C), width: 2)
            : null,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Card Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: method.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    method.icon,
                    color: method.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Card Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method.type == PaymentType.creditCard
                            ? '•••• •••• •••• ${method.lastFour}'
                            : method.phoneNumber ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      if (method.expiryDate != null)
                        Text(
                          'Expires: ${method.expiryDate}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Default Badge
                if (method.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB71C1C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Actions (Overflow menu)
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              itemBuilder: (context) => [
                if (!method.isDefault)
                  PopupMenuItem(
                    child: const Text('Set as Default'),
                    onTap: () => _setDefaultPayment(method.id),
                  ),
                PopupMenuItem(
                  child: const Text('Edit'),
                  onTap: () {
                    // Navigate to edit page
                  },
                ),
                PopupMenuItem(
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  onTap: () => _deletePaymentMethod(method.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ADD PAYMENT BUTTON ====================
  
  Widget _buildAddPaymentButton() {
    return GestureDetector(
      onTap: _showAddPaymentDialog,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Add New Payment Method',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PAYMENT METHOD MODEL ====================

enum PaymentType {
  creditCard,
  debitCard,
  mobileMoney,
  bankTransfer,
}

class PaymentMethod {
  final String id;
  final PaymentType type;
  final String name;
  final String? lastFour;
  final String? expiryDate;
  final String? phoneNumber;
  bool isDefault;
  final IconData icon;
  final Color color;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.lastFour,
    this.expiryDate,
    this.phoneNumber,
    this.isDefault = false,
    required this.icon,
    required this.color,
  });
}

// ==================== ADD PAYMENT SHEET ====================

class AddPaymentSheet extends StatefulWidget {
  const AddPaymentSheet({Key? key}) : super(key: key);

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  String _selectedType = 'Credit Card';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<String> _paymentTypes = [
    'Credit Card',
    'Debit Card',
    'Mobile Money',
    'Bank Transfer',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Add Payment Method',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          
          // Payment Type Dropdown
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              labelText: 'Payment Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.payment),
            ),
            items: _paymentTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Card Number
          if (_selectedType == 'Credit Card' || _selectedType == 'Debit Card')
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
            ),
          
          if (_selectedType == 'Credit Card' || _selectedType == 'Debit Card')
            const SizedBox(height: 16),
          
          // Name on Card
          if (_selectedType == 'Credit Card' || _selectedType == 'Debit Card')
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name on Card',
                hintText: 'John Doe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
          
          if (_selectedType == 'Credit Card' || _selectedType == 'Debit Card')
            const SizedBox(height: 16),
          
          // Expiry & CVV Row
          if (_selectedType == 'Credit Card' || _selectedType == 'Debit Card')
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          
          // Mobile Money
          if (_selectedType == 'Mobile Money')
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '0712345678',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          
          const SizedBox(height: 24),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment method added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Payment Method',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}