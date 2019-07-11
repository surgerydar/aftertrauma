package uk.co.soda.aftertrauma2;

// Qt
import org.qtproject.qt5.android.QtNative;
import org.qtproject.qt5.android.bindings.QtActivity;

// android
import android.app.Notification;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class NotificationHandler extends QtActivity {

    private static Intent currentIntent = null;

    public static int getNotificationId() {
        int notificationId = 0;
        if ( currentIntent == null ) {
            currentIntent = QtNative.activity().getIntent();
        }
        if ( currentIntent != null ) {
            //Activity context = QtNative.activity();
            notificationId = currentIntent.getIntExtra(NotificationPublisher.NOTIFICATION_ID,0);
            if ( notificationId > 0 ) {
                //
                // clear notification id
                //
                currentIntent.putExtra(NotificationPublisher.NOTIFICATION_ID,0);
            }
        }
        return notificationId;
    }
    //
    //
    //
    @Override
    public void startActivity(Intent intent) {
        System.out.println("NotificationHandler.startActivity(Intent intent)");
        currentIntent = intent;
        super.startActivity(intent);
    }
    @Override
    public void startActivity(Intent intent, Bundle options) {
        System.out.println("NotificationHandler.startActivity(Intent intent, Bundle options)");
        currentIntent = intent;
        super.startActivity(intent,options);
    }
    @Override
    public void startActivityForResult(Intent intent, int requestCode) {
        System.out.println("NotificationHandler.startActivityForResult(Intent intent, int requestCode)");
        currentIntent = intent;
        super.startActivityForResult(intent,requestCode);
    }
    //
    //
    //
    @Override
    public void onCreate(Bundle savedInstanceState) {
        System.out.println("NotificationHandler.onCreate(Bundle savedInstanceState)");
        super.onCreate(savedInstanceState);
        currentIntent = getIntent();
        System.out.println("NotificationHandler.onCreate : notification id=" + currentIntent.getIntExtra(NotificationPublisher.NOTIFICATION_ID,0) );
    }
    @Override
    protected void onNewIntent(Intent intent)
    {
        System.out.println("NotificationHandler.onNewIntent(Intent intent)");
        currentIntent = intent;
        super.onNewIntent(intent);
    }
}
