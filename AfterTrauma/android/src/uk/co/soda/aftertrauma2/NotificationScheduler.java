package uk.co.soda.aftertrauma2;

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
import java.util.Calendar;

public class NotificationScheduler {
    /*
        pattern indicies
    */
    public static final int HOURLY                = 0;
    public static final int FOUR_TIMES_DAILY      = 1;
    public static final int MORNING_AND_EVENING   = 2;
    public static final int DAILY                 = 3;
    public static final int WEEKLY                = 4;
    /*

    */
    public static void show( int id, String message, int delay, int frequency ) {
        System.out.println("show");
        scheduleNotification( id, getNotification( id, message ), delay, frequency );
    }

    public static void showByDate( int id, String message, int weekday, int hour ) {
        System.out.println("showByDate");
        Context context = QtNative.activity();

        Intent notificationIntent = new Intent(context, NotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, id);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, getNotification( id, message ));
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        Calendar now = Calendar.getInstance();
        now.setTimeInMillis(System.currentTimeMillis());
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(System.currentTimeMillis());
        cal.set(Calendar.HOUR_OF_DAY, hour);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        if ( weekday > 0 ) {
            cal.set(Calendar.DAY_OF_WEEK, weekday);
            if (now.after(cal)) {
                cal.add(Calendar.WEEK_OF_YEAR, 1);
            }
        } else {
            if (now.after(cal)) {
                cal.add(Calendar.DAY_OF_MONTH, 1);
            }
        }

        AlarmManager alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, cal.getTimeInMillis(), AlarmManager.INTERVAL_DAY * ( weekday > 0 ? 7 : 1 ), pendingIntent);

        //show( id, message, 0, 0 );
    }

    private static void scheduleNotification( int id, Notification notification, int delay, int frequency) {
        Context context = QtNative.activity();

        Intent notificationIntent = new Intent(context, NotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, id);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, notification);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        long futureInMillis = SystemClock.elapsedRealtime() + delay;
        AlarmManager alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        if ( frequency > 0 ) {
            alarmManager.setInexactRepeating(AlarmManager.ELAPSED_REALTIME_WAKEUP, futureInMillis, frequency, pendingIntent);
        } else {
            alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, futureInMillis, pendingIntent);
        }
    }

    private static void scheduleNotification( int id, Notification notification, int pattern) {
        /*
            TODO: schedule mutiple alarms
            Use Calendar to:
            0 : hourly, schedule single notification to start at the begining of the next hour and repeat hourly ( waking hours? )
            1 : fourtimesdaily, schedule 4 notifications at 4 times during waking hours, each should repeat daily
            2 : morningandevening, schedule 2 notifications at 2 times during waking hours, each should repeat daily
            4 : daily, schedule single notification to trigger at start of day ( 8:00 ? ) and repeat daily
            5 : weekly, schedule single notification to trigger at start of day on monday, repeat weekly

            Context context = QtNative.activity();

            Intent notificationIntent = new Intent(context, NotificationPublisher.class);
            notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, id);
            notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, notification);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            long futureInMillis = SystemClock.elapsedRealtime() + delay;
            AlarmManager alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
            if ( frequency > 0 ) {
                alarmManager.setInexactRepeating(AlarmManager.ELAPSED_REALTIME_WAKEUP, futureInMillis, frequency, pendingIntent);
            } else {
                alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, futureInMillis, pendingIntent);
            }
        */
    }

    private static Notification getNotification(int id, String content) {
        Context context = QtNative.activity();
        Intent intent = new Intent(context,context.getClass());
        intent.putExtra(NotificationPublisher.NOTIFICATION_ID, id);
        intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        int uniqueId = (int) (System.currentTimeMillis() & 0xfffffff);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, uniqueId, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        //
        //
        //
        Notification.Builder builder = null;
        if ( android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O ) {
            builder = new Notification.Builder(context,NotificationPublisher.NOTIFICATION_CHANNEL_ID);
        } else {
            builder = new Notification.Builder(context);
        }
        //builder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_VIBRATE);
        builder.setDefaults(Notification.DEFAULT_SOUND);
        builder.setContentTitle("AfterTrauma");
        builder.setContentText(content);
        builder.setSmallIcon(R.drawable.notification_icon);
        builder.setPriority( NotificationManager.IMPORTANCE_HIGH );
        builder.setContentIntent(pendingIntent);

        return builder.build();
    }

    public static void hide(int id) {
        Context context = QtNative.activity();
        Intent notificationIntent = new Intent(context, NotificationPublisher.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        AlarmManager alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        alarmManager.cancel(pendingIntent);
    }

    public static void hideAll() {
        getManager().cancelAll();
    }

    private static NotificationManager getManager() {
        Context context = QtNative.activity();
        return (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    }

}

