import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/provider/send_email/send_email_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/widgets/form/email_list.dart';

class SendEmail extends ConsumerWidget {
  final EmailAndLabels emailsAndLabelsDefault;
  final int idRegistro;
  final nuevoEmailController = TextEditingController();
  SendEmail({
    Key? key,
    required this.emailsAndLabelsDefault,
    required this.idRegistro,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendEmailState = ref.watch(sendEmailProvider(emailsAndLabelsDefault));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sendEmailState.labels.map((label) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        '${label.label}: ',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        label.value,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            CustomInputField(
              autofocus: true,
              label: 'Correo',
              onFieldSubmitted: (_) {
                ref
                    .read(sendEmailProvider(emailsAndLabelsDefault).notifier)
                    .agregarEmail(nuevoEmailController);
              },
              controller: nuevoEmailController,
              onChanged: (p0) {
                ref
                    .read(sendEmailProvider(emailsAndLabelsDefault).notifier)
                    .updateState(nuevoEmail: p0);
              },
              errorMessage: sendEmailState.nuevoEmail.errorMessage,
              suffixIcon: IconButton(
                  onPressed: () {
                    ref
                        .read(
                            sendEmailProvider(emailsAndLabelsDefault).notifier)
                        .agregarEmail(nuevoEmailController);
                  },
                  icon: const Icon(Icons.add_circle_outline)),
            ),
            const Text(
              'Emails:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            EmailList(
              emails: sendEmailState.emails.value,
              eliminarEmail: (String e) {
                print(e);
                ref
                    .read(sendEmailProvider(emailsAndLabelsDefault).notifier)
                    .eliminarEmail(e);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (sendEmailState.status.isPosting) {
            return;
          }
          final exitoso = await ref
              .read(sendEmailProvider(emailsAndLabelsDefault).notifier)
              .onFormSubmit(idRegistro);

          if (exitoso && context.mounted) {
            NotificationsService.show(
                context, 'Email Enviado', SnackbarCategory.success);
          }
        },
        icon: sendEmailState.status.isPosting
            ? SpinPerfect(
                duration: const Duration(seconds: 1),
                spins: 10,
                infinite: true,
                child: const Icon(Icons.refresh),
              )
            : const Icon(Icons.send),
        label: const Text('Enviar Email'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
