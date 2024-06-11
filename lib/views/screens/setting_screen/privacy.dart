import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Introduction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our pet tracking platform. Please read this policy carefully to understand our views and practices regarding your personal data and how we will treat it.',
              ),
              SizedBox(height: 16),
              Text(
                'Information We Collect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We may collect and process the following data about you: '
                '• Information you provide by filling in forms on our site. '
                '• Records of your correspondence if you contact us. '
                '• Details of your visits to our site and the resources you access.',
              ),
              SizedBox(height: 16),
              Text(
                'How We Use Your Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We use the information we collect in the following ways: '
                '• To provide, operate, and maintain our services. '
                '• To improve, personalize, and expand our services. '
                '• To understand and analyze how you use our services.',
              ),
              SizedBox(height: 16),
              Text(
                'Disclosure of Your Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We may share the information we collect about you in the following situations: '
                '• With your consent. '
                '• For legal reasons. '
                '• To protect and defend our rights and property.',
              ),
              SizedBox(height: 16),
              Text(
                'Security of Your Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable.',
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns about this Privacy Policy, please contact us at: '
                '• Email: support@petstrackingplatform.com '
                '• Phone: (123) 456-7890',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
