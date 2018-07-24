package uk.co.soda;

// Qt
import org.qtproject.qt5.android.QtNative;


// android
import android.content.Intent;
import android.content.Context;
import android.app.PendingIntent;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.AlarmManager;
import android.os.SystemClock;
import android.os.Bundle;

// java
import java.lang.String;

public class NotificationScheduler {

    public static void show(String title, String caption, int id) {
        System.out.println("show");
        scheduleNotification( getNotification( caption ), 0 );
        /*
        Context context = QtNative.activity();

        NotificationManager notificationManager = getManager();
        Notification.Builder builder =
                new Notification.Builder(context)
                .setSmallIcon(R.drawable.app_icon)
                .setContentTitle(title)
                .setContentText(caption)
                .setAutoCancel(true)
                ;

        String packageName = context.getApplicationContext().getPackageName();
        Intent resultIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
        resultIntent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);

        PendingIntent resultPendingIntent =
            PendingIntent.getActivity(
            context, 0,
            resultIntent, PendingIntent.FLAG_UPDATE_CURRENT
        );

        builder.setContentIntent(resultPendingIntent);

        notificationManager.notify(id, builder.build());
        */
    }

    private static void scheduleNotification(Notification notification, int delay) {
        Context context = QtNative.activity();

        Intent notificationIntent = new Intent(context, NotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, 1);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, notification);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        long futureInMillis = SystemClock.elapsedRealtime() + delay;
        AlarmManager alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        //alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, futureInMillis, pendingIntent);
        alarmManager.setInexactRepeating(AlarmManager.ELAPSED_REALTIME_WAKEUP, futureInMillis, 60000, pendingIntent);
    }

    private static Notification getNotification(String content) {
        Context context = QtNative.activity();
        Notification.Builder builder = new Notification.Builder(context);
        builder.setContentTitle("Scheduled Notification");
        builder.setContentText(content);
        //builder.setSmallIcon(android.R.drawable.ic_delete);
        builder.setSmallIcon(R.drawable.notification_icon);
        builder.setPriority( NotificationManager.IMPORTANCE_HIGH );
        return builder.build();
    }

    public static void hide(int id) {
        getManager().cancel(id);
    }

    public static void hideAll() {
        getManager().cancelAll();
    }

    private static NotificationManager getManager() {
        Context context = QtNative.activity();
        return (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    }

}

/*
public void scheduleNotification(Context context, long delay, int notificationId) {//delay is after how much time(in millis) from current time you want to schedule the notification
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context)
                .setContentTitle(context.getString(R.string.title))
                .setContentText(context.getString(R.string.content))
                .setAutoCancel(true)
                .setSmallIcon(R.drawable.app_icon)
                .setLargeIcon(((BitmapDrawable) context.getResources().getDrawable(R.drawable.app_icon)).getBitmap())
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION));

        Intent intent = new Intent(context, YourActivity.class);
        PendingIntent activity = PendingIntent.getActivity(context, notificationId, intent, PendingIntent.FLAG_CANCEL_CURRENT);
        builder.setContentIntent(activity);

        Notification notification = builder.build();

        Intent notificationIntent = new Intent(context, MyNotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, notificationId);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, notification);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, notificationId, notificationIntent, PendingIntent.FLAG_CANCEL_CURRENT);

        long futureInMillis = SystemClock.elapsedRealtime() + delay;
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, futureInMillis, pendingIntent);
    }
*/
