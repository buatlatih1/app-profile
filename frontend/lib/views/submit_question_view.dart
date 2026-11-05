import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/inquiry_provider.dart';

class SubmitQuestionView extends StatefulWidget {
  const SubmitQuestionView({super.key});

  @override
  State<SubmitQuestionView> createState() => _SubmitQuestionViewState();
}

class _SubmitQuestionViewState extends State<SubmitQuestionView> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedTopicId;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InquiryProvider>().resetSubmitState();
      final topics = context.read<InquiryProvider>().topics;
      if (topics.isNotEmpty && _selectedTopicId == null) {
        setState(() {
          _selectedTopicId = topics.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTopicId == null) return;

    final provider = context.read<InquiryProvider>();
    final success = await provider.submitInquiry(
      topicId: _selectedTopicId!,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      subject: _subjectController.text,
      body: _bodyController.text,
    );

    if (success) {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _bodyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<InquiryProvider>();
    final isDesktop = Breakpoints.isDesktop(context);

    // Auto-select first topic if not yet set and topics become available
    if (_selectedTopicId == null && provider.topics.isNotEmpty) {
      _selectedTopicId = provider.topics.first.id;
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 720),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16,
          vertical: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            InkWell(
              onTap: () => context.go('/questions'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_rounded, size: 18, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.text('back'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (provider.submitSuccess)
              _buildSuccessView(context, l10n)
            else
              _buildFormView(context, provider, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView(
    BuildContext context,
    InquiryProvider provider,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.text('form_title'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.text('form_desc'),
                style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.5),
              ),
              const SizedBox(height: 24),

              // Error banner if any
              if (provider.submitError != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          provider.submitError!,
                          style: TextStyle(fontSize: 13, color: Colors.red.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Topic Dropdown
              Text(
                l10n.text('field_topic'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedTopicId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined, color: AppTheme.textMuted),
                ),
                items: provider.topics.map((t) {
                  return DropdownMenuItem<int>(
                    value: t.id,
                    child: Text(t.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedTopicId = val);
                },
                validator: (val) => val == null ? l10n.text('validation_required') : null,
              ),
              const SizedBox(height: 18),

              // Name Field
              Text(
                l10n.text('field_name'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.text('field_name_hint'),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppTheme.textMuted),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return l10n.text('validation_required');
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Email Field
              Text(
                l10n.text('field_email'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: l10n.text('field_email_hint'),
                  prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.textMuted),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return l10n.text('validation_required');
                  if (!val.contains('@') || !val.contains('.')) return l10n.text('validation_email_invalid');
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Phone Field (Optional)
              Text(
                l10n.text('field_phone'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: l10n.text('field_phone_hint'),
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 18),

              // Subject Field
              Text(
                l10n.text('field_subject'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: l10n.text('field_subject_hint'),
                  prefixIcon: const Icon(Icons.subject_rounded, color: AppTheme.textMuted),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return l10n.text('validation_required');
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Body Field
              Text(
                l10n.text('field_body'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: l10n.text('field_body_hint'),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return l10n.text('validation_required');
                  if (val.trim().length < 10) return l10n.text('validation_body_min');
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: provider.isSubmitting ? null : _handleSubmit,
                  icon: provider.isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    provider.isSubmitting ? l10n.text('submitting_btn') : l10n.text('submit_btn'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7), // Green-100
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF16A34A),
                size: 54,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.text('submit_success_title'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.text('submit_success_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.read<InquiryProvider>().resetSubmitState();
                  },
                  child: Text(l10n.text('send_another')),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => context.go('/questions'),
                  child: Text(l10n.text('view_all')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

