<?php

namespace App\Notifications;

use App\Models\Question;
use App\Models\QuestionAnswer;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class QuestionAnsweredNotification extends Notification
{
    use Queueable;

    public function __construct(
        public Question $question,
        public QuestionAnswer $answer
    ) {}

    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Tanggapan Atas Pertanyaan Anda: '.$this->question->subject)
            ->greeting('Yth. '.$this->question->name.',')
            ->line('Terima kasih telah menghubungi kami melalui portal pelayanan masyarakat.')
            ->line('Pertanyaan Anda mengenai "'.$this->question->subject.'" telah ditanggapi oleh tim kami.')
            ->line('**Tanggapan Kami:**')
            ->line($this->answer->body)
            ->line('Semoga jawaban ini dapat membantu. Jika masih memerlukan informasi lebih lanjut, silakan sampaikan kembali melalui portal kami.')
            ->salutation('Salam hormat,'.PHP_EOL.config('app.name', 'Portal Pelayanan Instansi'));
    }
}
