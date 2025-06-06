import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedOperator = 'Ucell';
  bool _isLoading = false;

  final List<String> _operators = [
    'Ucell',
    'Beeline',
    'Uzmobile',
    'Mobiuz',
    'Oq'
  ];

  final Map<String, Color> _operatorColors = {
    'Ucell': Colors.purple,
    'Beeline': Colors.yellow,
    'Uzmobile': Colors.red,
    'Mobiuz': Colors.blue,
    'Oq': Colors.white,
  };

  final Map<String, String> _operatorPrefixes = {
    'Ucell': '93, 94, 90',
    'Beeline': '99, 91',
    'Uzmobile': '95, 97',
    'Mobiuz': '98',
    'Oq': '92',
  };

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _makePayment() async {
    if (_phoneController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, barcha maydonlarni to\'ldiring')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Bu yerda haqiqiy to'lov logikasi bo'ladi
    // Simulyatsiya uchun 2 soniya kutish
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // To'lov muvaffaqiyatli bo'ldi deb hisoblaymiz
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('To\'lov muvaffaqiyatli amalga oshirildi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operator: $_selectedOperator'),
            Text('Telefon: ${_phoneController.text}'),
            Text('Summa: ${_amountController.text} so\'m'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Sahifadan chiqish
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobil operatorga to\'lov'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Operator tanlash
            _buildOperatorSelector(),
            const SizedBox(height: 20),

            // Telefon raqami
            _buildPhoneInput(),
            const SizedBox(height: 16),

            // To'lov summasi
            _buildAmountInput(),
            const SizedBox(height: 24),

            // To'lov tugmasi
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobil operatorni tanlang',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedOperator,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.sim_card,
                color: _operatorColors[_selectedOperator]),
          ),
          items: _operators.map((operator) {
            return DropdownMenuItem(
              value: operator,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _operatorColors[operator],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(operator),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedOperator = value!);
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Prefikslar: ${_operatorPrefixes[_selectedOperator]}',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Telefon raqami',
        prefixText: '+998 ',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
        hintText: 'XX XXX XX XX',
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
        _PhoneNumberFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Iltimos, telefon raqamini kiriting';
        }
        if (value.length != 9) {
          return 'Telefon raqami 9 raqamdan iborat bo\'lishi kerak';
        }
        return null;
      },
    );
  }

  Widget _buildAmountInput() {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'To\'lov summasi',
        prefixText: 'so\'m ',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money),
        suffixText: 'UZS',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Iltimos, summani kiriting';
        }
        if (int.tryParse(value) == null) {
          return 'Noto\'g\'ri summa formati';
        }
        if (int.parse(value) < 1000) {
          return 'Minimal to\'lov summasi 1,000 so\'m';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _makePayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: _operatorColors[_selectedOperator],
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
        "TO'LOV QILISH",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length) {
      String formattedText = newValue.text;

      if (formattedText.length > 2) {
        formattedText = formattedText.substring(0, 2) +
            ' ' + formattedText.substring(2);
      }
      if (formattedText.length > 6) {
        formattedText = formattedText.substring(0, 6) +
            ' ' + formattedText.substring(6);
      }
      if (formattedText.length > 9) {
        formattedText = formattedText.substring(0, 9);
      }

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
    return newValue;
  }
}