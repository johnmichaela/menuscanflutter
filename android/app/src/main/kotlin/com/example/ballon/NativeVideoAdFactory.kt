package com.skylarkx.menuscan // CHANGE THIS to your package name

import android.content.Context
import android.view.LayoutInflater
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeVideoAdFactory(private val context: Context) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_video_ad_layout, null) as NativeAdView

        val iconView    = adView.findViewById<ImageView>(R.id.ad_app_icon)
        val headline    = adView.findViewById<TextView>(R.id.ad_headline)
        val advertiser  = adView.findViewById<TextView>(R.id.ad_advertiser)
        val body        = adView.findViewById<TextView>(R.id.ad_body)
        val cta         = adView.findViewById<Button>(R.id.ad_call_to_action)
        val mediaView   = adView.findViewById<MediaView>(R.id.ad_media)

        adView.headlineView    = headline
        adView.bodyView        = body
        adView.callToActionView = cta
        adView.iconView        = iconView
        adView.mediaView       = mediaView

        headline.text   = nativeAd.headline
        body.text       = nativeAd.body
        advertiser.text = nativeAd.advertiser
        cta.text        = nativeAd.callToAction ?: "Learn more"

        nativeAd.icon?.let { iconView.setImageDrawable(it.drawable) }

        // 🔑 This is what makes video ads play inline
        mediaView.mediaContent = nativeAd.mediaContent

        adView.setNativeAd(nativeAd)
        return adView
    }
}