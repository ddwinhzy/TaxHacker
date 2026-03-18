import { default as globalConfig } from "@/lib/config"
import { getSessionCookie } from "better-auth/cookies"
import createMiddleware from "next-intl/middleware"
import { NextRequest, NextResponse } from "next/server"
import { routing } from "./routing"

const intlMiddleware = createMiddleware(routing)

export default async function middleware(request: NextRequest) {
  if (globalConfig.selfHosted.isEnabled) {
    return intlMiddleware(request)
  }

  const sessionCookie = getSessionCookie(request, { cookiePrefix: "taxhacker" })
  if (!sessionCookie) {
    const loginUrl = new URL(globalConfig.auth.loginUrl, request.url)
    loginUrl.searchParams.set("locale", request.headers.get("x-your-locale") || "en")
    return NextResponse.redirect(loginUrl)
  }

  return intlMiddleware(request)
}

export const config = {
  matcher: [
    "/((?!api|_next|_vercel|.*\\..*).*)",
  ],
}
