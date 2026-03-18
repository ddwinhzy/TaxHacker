"use client"

import { User } from "@/prisma/client"
import { PricingCard } from "@/components/auth/pricing-card"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import config from "@/lib/config"
import { PLANS } from "@/lib/stripe"
import { formatBytes, formatNumber } from "@/lib/utils"
import { formatDate } from "date-fns"
import { BrainCog, CalendarSync, HardDrive } from "lucide-react"
import { useTranslations } from "next-intl"
import Link from "next/link"
import { Badge } from "../ui/badge"

export function SubscriptionPlan({ user }: { user: User }) {
  const t = useTranslations("subscription")
  const tCommon = useTranslations("common")

  const plan = PLANS[user.membershipPlan as keyof typeof PLANS] || PLANS.unlimited

  return (
    <div className="flex flex-wrap gap-5">
      <div className="flex flex-col gap-2 flex-1 items-center justify-center max-w-[300px]">
        <PricingCard plan={plan} hideButton={true} />
        <Badge variant="outline">{t("currentPlan")}</Badge>
      </div>
      <div className="flex-1">
        <Card className="w-full p-4">
          <div className="space-y-2">
            <strong className="text-lg">{tCommon("usage") || "Usage"}:</strong>
            <div className="flex items-center gap-2">
              <HardDrive className="h-4 w-4" />
              <span>
                <strong className="font-semibold">{t("storage") || "Storage"}:</strong> {formatBytes(user.storageUsed)} /{" "}
                {user.storageLimit > 0 ? formatBytes(user.storageLimit) : "Unlimited"}
              </span>
            </div>
            <div className="flex items-center gap-2">
              <BrainCog className="h-4 w-4" />
              <span>
                <strong className="font-semibold">{t("aiAnalyses") || "AI Analyses"}:</strong> {formatNumber(plan.limits.ai - user.aiBalance)}{" "}
                / {plan.limits.ai > 0 ? formatNumber(plan.limits.ai) : "Unlimited"}
              </span>
            </div>
            <div className="flex items-center gap-2">
              <CalendarSync className="h-4 w-4" />
              <span>
                <strong className="font-semibold">{t("expirationDate")}</strong>{" "}
                {user.membershipExpiresAt ? formatDate(user.membershipExpiresAt, "yyyy-MM-dd") : "Never"}
              </span>
            </div>
          </div>

          <div className="space-y-4 mt-6 text-center">
            {user.stripeCustomerId && (
              <Button asChild className="w-full">
                <Link href="/api/stripe/portal">{t("manageSubscription")}</Link>
              </Button>
            )}

            {!user.stripeCustomerId && user.membershipExpiresAt && (
              <Button asChild className="w-full">
                <Link href="/cloud">{t("buySubscription")}</Link>
              </Button>
            )}

            <Link href={`mailto:${config.app.supportEmail}`} className="block text-sm text-muted-foreground">
              {t("contactUs") || "Contact Us"}
            </Link>
          </div>
        </Card>
      </div>
    </div>
  )
}
