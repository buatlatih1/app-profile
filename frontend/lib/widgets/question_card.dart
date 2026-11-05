import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../models/question_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;

  const QuestionCard({super.key, required this.question});

  String _formatDate(DateTime? dt, String lang) {
    if (dt == null) return '';
    try {
      final formatter = DateFormat('dd MMM yyyy, HH:mm', lang == 'en' ? 'en_US' : 'id_ID');
      return formatter.format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.locale.languageCode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Topic & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (question.topic != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      question.topic!.name,
                      style: const TextStyle(
                        color: AppTheme.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: question.isAnswered ? Colors.green.shade50 : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: question.isAnswered ? Colors.green.shade200 : Colors.amber.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        question.isAnswered ? Icons.check_circle_rounded : Icons.schedule_rounded,
                        size: 13,
                        color: question.isAnswered ? Colors.green.shade700 : Colors.amber.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        question.isAnswered
                            ? l10n.text('status_answered')
                            : l10n.text('status_pending'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: question.isAnswered ? Colors.green.shade800 : Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Subject
            Text(
              question.subject,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 6),

            // Submitter & Date
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, size: 14, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  question.name,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  _formatDate(question.createdAt, lang),
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question Body
            Text(
              question.body,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF334155),
                height: 1.5,
              ),
            ),

            // Official Answer Section
            if (question.isAnswered) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4), // Emerald-50
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, size: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.text('official_answer'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                        ),
                        if (question.answer?.answeredAt != null) ...[
                          const Spacer(),
                          Text(
                            _formatDate(question.answer!.answeredAt, lang),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      question.answer!.body,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF1E293B),
                        height: 1.5,
                      ),
                    ),
                    if (question.answer?.authorName != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '— ${question.answer!.authorName}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF166534),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

