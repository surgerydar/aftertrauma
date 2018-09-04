package uk.co.soda;

// Qt
import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.QtNative;

// android
import android.content.Context;
import android.content.Intent;
import android.content.ContentResolver;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.support.v4.content.FileProvider;

// java
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ImagePicker {

    static final String AUTHORITY = "uk.co.soda.fileprovider";

    /*
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
       if (resultCode == RESULT_OK)
        {
            if(requestCode == REQUEST_OPEN_IMAGE)
            {
                String filePath = getRealPathFromURI(getApplicationContext(), data.getData());
                fileSelected(filePath);
            }
        }
        else
        {
            fileSelected(":(");
        }

        super.onActivityResult(requestCode, resultCode, data);
    }
    */
    public String getRealPathFromURI(Context context, Uri contentUri)
    {
        return getRealPathFromURI( context.getContentResolver(), contentUri);
    }

    static public String getRealPathFromURI(ContentResolver contentResolver, Uri contentUri) {
        Cursor cursor = null;
        try {
            String[] proj = { MediaStore.Images.Media.DATA };
            cursor = contentResolver.query(contentUri,  proj, null, null, null);
            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            return cursor.getString(column_index);
        } finally  {
            if (cursor != null) {
                cursor.close();
            }
        }
    }
    //
    //
    //
    public static String mCurrentPhotoPath;

    private static File createImageFile() throws IOException {
        // Create an image file name
        //Context context = QtNative.activity();
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        //File storageDir = context.getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        File storageDir = Environment.getExternalStorageDirectory();
        File image = File.createTempFile(
            imageFileName,  /* prefix */
            ".jpg",         /* suffix */
            storageDir      /* directory */
        );

        // Save a file: path for use with ACTION_VIEW intents
        mCurrentPhotoPath = image.getAbsolutePath();
        return image;
    }
    //
    //
    //
    public static Intent openCamera() {
        Context context = QtNative.activity();
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // Ensure that there's a camera activity to handle the intent
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            // Create the File where the photo should go
            File photoFile = null;
            try {
                photoFile = createImageFile();
            } catch (IOException ex) {
                // Error occurred while creating the File
                //System.println( "Error opening photoFile" );
            }
            // Continue only if the File was successfully created
            if (photoFile != null) {
                Uri photoURI = FileProvider.getUriForFile(context,
                                                      AUTHORITY,
                                                      photoFile);
                intent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                return intent;
            }
        }
        return null;
    }
    //
    //
    //
    public static Intent openGallery() {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("image/*");
        return intent;
    }
}
