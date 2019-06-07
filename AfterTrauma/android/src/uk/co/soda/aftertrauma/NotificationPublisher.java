package uk.co.soda.aftertrauma;

// Qt
import org.qtproject.qt5.android.QtNative;

// android
import android.app.Notification;
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

// java
import java.lang.String;

public class NotificationPublisher extends BroadcastReceiver {

    public static String NOTIFICATION_CHANNEL_ID    = "aftertrauma-notification-channel";
    public static String NOTIFICATION_CHANNEL_NAME  = "AfterTrauma Notifications";
    public static String NOTIFICATION_ID            = "notification-id";
    public static String NOTIFICATION               = "notification";

    public void onReceive(Context context, Intent intent) {
        //System.out.println("NotificationPublisher.onReceive");

        NotificationManager notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(NOTIFICATION_CHANNEL_ID,NOTIFICATION_CHANNEL_NAME,NotificationManager.IMPORTANCE_HIGH);
            notificationManager.createNotificationChannel(channel);
        }
        Notification notification = intent.getParcelableExtra(NOTIFICATION);
        int id = intent.getIntExtra(NOTIFICATION_ID, 0);
        System.out.println("NotificationPublisher.onReceive : notififaction id=" + id );
        notificationManager.notify(id, notification);
        /*
        String packageName = context.getApplicationContext().getPackageName();
        System.out.println( packageName );
        */
    }
}
