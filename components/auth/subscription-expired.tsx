"use client"

import { useTranslations } from "next-intl"
import Link from "next/link"

export function SubscriptionExpired() {
  const t = useTranslations("subscription")

  return (
    <Link
      href="/settings/profile"
      className="w-full h-8 p-1 bg-red-500 text-white font-semibold text-center hover:bg-red-600 transition-colors"
    >
      {t("expired")}
    </Link>
  )
}
