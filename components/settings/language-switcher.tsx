"use client"

import { useLocale, useTranslations } from "next-intl"
import { useRouter } from "next/navigation"

export function LanguageSwitcher() {
  const locale = useLocale()
  const t = useTranslations("common")
  const router = useRouter()

  const toggleLocale = () => {
    const newLocale = locale === "en" ? "zh" : "en"
    router.replace(`/${newLocale}`)
  }

  return (
    <button
      onClick={toggleLocale}
      className="flex items-center gap-2 px-3 py-2 text-sm text-muted-foreground hover:text-foreground transition-colors"
      title={t("language") || "Language"}
    >
      <span className="text-lg">{locale === "en" ? "🇺🇸" : "🇨🇳"}</span>
      <span>{locale === "en" ? "EN" : "中文"}</span>
    </button>
  )
}
