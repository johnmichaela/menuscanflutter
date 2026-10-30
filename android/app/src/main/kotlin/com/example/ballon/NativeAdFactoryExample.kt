package com.skylarkx.menuscan // CHANGE THIS to your package name

import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactoryExample(private val context: android.content.Context) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_layout, null) as NativeAdView
        adView.setNativeAd(nativeAd)

        val iconView = adView.findViewById<ImageView>(R.id.ad_app_icon)
        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = adView.findViewById<TextView>(R.id.ad_body)
        val ctaView = adView.findViewById<Button>(R.id.ad_call_to_action)

        adView.headlineView = headlineView
        adView.bodyView = bodyView
        adView.callToActionView = ctaView
        adView.iconView = iconView

        headlineView.text = nativeAd.headline
        bodyView.text = nativeAd.body
        ctaView.text = nativeAd.callToAction

        nativeAd.icon?.let { iconView.setImageDrawable(it.drawable) }

        return adView
    }
}