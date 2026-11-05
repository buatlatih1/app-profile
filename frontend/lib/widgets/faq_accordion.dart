import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/faq_model.dart';

class FaqAccordion extends StatelessWidget {
  final FaqModel faq;

  const FaqAccordion({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline_rounded, color: AppTheme.primary, size: 20),
          ),
          title: Text(
            faq.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
          subtitle: faq.topic != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    faq.topic!.name,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

