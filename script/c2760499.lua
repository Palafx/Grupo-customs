--Orfo the Obvlivious Observer
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
  e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.thfilter(c,e,tp)
	return c:IsMonster() or c:IsSpellTrap()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
  --draw 2, discard 1
	if ct>15 then
    Duel.Draw(tp,2,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
  end
  --draw 1
	if ct<16 and ct>10 then
    Duel.Draw(tp,1,REASON_EFFECT)
  end
  --gain 100 LP for each card on field and gy
  if ct<11 and ct>5 then
    local rt=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_GRAVE,0)*100
    Duel.Recover(tp,rt,REASON_EFFECT)
  end
  --special summon
  if ct<6 and ct>0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
  end
  --search
	if ct==0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	  if #g>0 then
		  Duel.SendtoHand(g,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,g)
    end
  end
end