package uk.co.soda.aftertrauma;

// Qt
import org.qtproject.qt5.android.QtNative;


// android
import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.util.Log;

public class Permissions {

    public static void request() {
        Activity activity = QtNative.activity();
        System.out.println( "Permissions.request : checking permissions" );
        Log.d("Permissions.request", "checking permissions" );
        if ( activity.checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED ) {
            /*
            <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
            <uses-permission android:name="android.permission.CAMERA"/>
            <uses-permission android:name="android.permission.READ_INTERNAL_STORAGE"/>
            <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
            */
            String[] permissions = {
                Manifest.permission.CAMERA,
                "android.permission.READ_EXTERNAL_STORAGE",
                "android.permission.READ_INTERNAL_STORAGE",
                "android.permission.WRITE_EXTERNAL_STORAGE"
                };
            ActivityCompat.requestPermissions(activity, permissions, 101);
            }
    }
    //
    //
    //
    /*
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case REQUEST_CODE_ASK_PERMISSIONS:
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission Granted
                    insertDummyContact();
                } else {
                    // Permission Denied
                    Toast.makeText(MainActivity.this, "WRITE_CONTACTS Denied", Toast.LENGTH_SHORT)
                            .show();
                }
                break;
            default:
                super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
    */
}
